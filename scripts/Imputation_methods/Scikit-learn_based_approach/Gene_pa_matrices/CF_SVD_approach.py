##Author : LM



"""
Part 1:Objective: Impute missing values using an SVD model trained on a reference matrix (ground truth).
- Load the reference matrix wich contains the ground truth of the presence and absence of genes in each genome.
- Load the simulated MAGs matrix with missing unkownn value (0's).
- Train an SVD model on the reference ground truth matrix.
- Use the trained model to impute missing values in the simulated matrix.
- Calculate the imputation accuracy by comparing it to the ground truth.

Part 2:use an SVD model to impute missing values in the simulated matrix, without knowing the ground truth (we don't use the reference matrix here)
- Load the simulated matrix with missing values.
- Split the data into training and testing sets.
- Train an SVD model on the training set.
- Evaluate the model using RMSE on the test set
- Impute missing values in the simulated matrix using the trained model.

"""




#Part 1 :

import pandas as pd
import numpy as np
from surprise import SVD, Dataset, Reader

# Set a random seed for reproducibility,
SEED = 42
np.random.seed(SEED)


# Load the reference matrix (ground truth)
reference_matrix = pd.read_csv('ref.csv', index_col=0).T
#print("Reference Matrix (Ground Truth):")
#print(reference_matrix)

# Load the simulated matrix (with missing values)
simulated_MAGs_matrix = pd.read_csv('mags.csv', index_col=0)
#print("\nSimulated Matrix (Original with Missing Values):")
simulated_MAGs_matrix = simulated_MAGs_matrix.T
#print(simulated_MAGs_matrix)

# Replace zeros with NaN to simulate missing values in the simulated matrix
simulated_MAGs_matrix.replace(0, np.nan, inplace=True)
#print(simulated_MAGs_matrix)
#simulated_MAGs_matrix=simulated_MAGs
# Reshape the data to the format required by surprise
def transform_to_surprise_format(df):
    """Transform the DataFrame into a list of tuples suitable for Surprise.
       Each tuple consists of (user, item, rating) where 'user' is the index,
       'item' is the column, and 'rating' is the value at df[item][user].
    """
    rows, cols = df.shape
    interactions = []
    for i in range(rows):
        for j in range(cols):
            if not pd.isna(df.iloc[i, j]):
                interactions.append((df.index[i], df.columns[j], df.iloc[i, j]))
    return interactions

# Prepare the ground truth dataset for surprise
reader = Reader(rating_scale=(0, 1))
ground_truth_data = Dataset.load_from_df(pd.DataFrame(transform_to_surprise_format(reference_matrix),
                                                      columns=['MAG', 'Gene', 'Value']),
                                         reader)

# Train the SVD algorithm on the ground truth data
trainset = ground_truth_data.build_full_trainset()
svd = SVD(random_state=SEED)
svd.fit(trainset)

# Function to fill missing values with predictions
def fill_missing_values_svd(df, algo):
    """ Fill missing values in the DataFrame using the SVD algorithm """
    filled_df = df.copy()
    for index, row in df.iterrows():
        for col in df.columns:
            if pd.isna(row[col]):
                pred = algo.predict(index, col).est
                # Round predictions to 0 or 1
                pred = 1 if pred >= 0.5 else 0
                filled_df.at[index, col] = pred
    return filled_df

# Impute the missing values in the simulated_MAGs matrix using the trained model
filled_simulated_MAGs = fill_missing_values_svd(simulated_MAGs, svd)

# Function to calculate accuracy by comparing with the ground truth matrix
def calculate_accuracy(filled_df, reference_df):
    comparison = (filled_df == reference_df)
    correct_predictions = comparison.sum().sum()
    total_values = comparison.size
    accuracy = correct_predictions / total_values
    return accuracy

# Calculate the accuracy of the imputation
accuracy = calculate_accuracy(filled_simulated_MAGs, reference_matrix)

# Display results
print("Reference Matrix (Ground Truth):")
print(reference_matrix)
print("\nSimulated Matrix (Original with Missing Values):")
print(simulated_MAGs)
print("\nImputed Matrix (Predicted):")
print(filled_simulated_MAGs)
print("\nAccuracy of Imputation: {:.2f}".format(accuracy))

##Generating the matrix in csv format


filled_simulated_MAGs = filled_simulated_MAGs.T
filled_simulated_MAGs = filled_simulated_MAGs.astype(int)
filled_simulated_MAGs.to_csv('CF_SVD_1.csv', index=True)


#######################


import numpy as np
import pandas as pd
from surprise import SVD, Dataset, Reader
from surprise.model_selection import cross_validate
from surprise import accuracy
from surprise.model_selection import train_test_split
np.random.seed(42)
# Create the data frame
# Load the simulated matrix (with missing values) from a CSV file
simulated_matrix = pd.read_csv('mags.csv', index_col=0)
print("\nSimulated Matrix (Original with Missing Values):")
simulated_matrix = simulated_matrix.T
print(simulated_matrix)
simulated_matrix.replace(0, np.nan, inplace=True)


df = simulated_matrix
print("data frame")
print(df)
# Convert the DataFrame to Surprise format
df_melt = df.reset_index().melt(id_vars=['index'], var_name='Gene', value_name='Value')
df_melt.dropna(inplace=True)  # Drop NA values to fit the model

# Define a reader specifying the value range
reader = Reader(rating_scale=(0, 1))

# Load the data from the DataFrame
data = Dataset.load_from_df(df_melt[['index', 'Gene', 'Value']], reader)

# Split data into training and test set
trainset, testset = train_test_split(data, test_size=0.1)

# Use the SVD algorithm
algo = SVD(random_state=42)

# Train the algorithm on the trainset, and predict ratings for the testset
algo.fit(trainset)
predictions = algo.test(testset)

# Compute and print Root Mean Squared Error
accuracy.rmse(predictions, verbose=True)

# Fill the original matrix with predictions
for i in range(len(df.index)):
    for j in range(len(df.columns)):
        if pd.isna(df.iloc[i, j]):
            # Predict values for missing data
            pred = algo.predict(str(df.index[i]), str(df.columns[j]))
            df.iloc[i, j] = 1 if pred.est > 0.999  else 0
             
            #df.iloc[i, j] = pred.est
df = df.astype(int)
print(df)




##Generating the matrix in csv format
df = df.T
df.to_csv('CF_SVD_2.csv', index = True)
