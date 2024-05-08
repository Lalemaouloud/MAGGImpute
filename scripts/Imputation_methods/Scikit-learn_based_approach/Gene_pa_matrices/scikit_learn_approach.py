####Author : LM


import numpy as np
import pandas as pd
from sklearn.impute import SimpleImputer, KNNImputer
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer
from sklearn import preprocessing
from sklearn.linear_model import BayesianRidge
import sys
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import ExtraTreesRegressor
from sklearn.neighbors import KNeighborsRegressor

from sklearn.preprocessing import StandardScaler



reference_matrix = pd.read_csv('gene_pa_SP_Before_simulation.csv', index_col=0)
reference_matrix = reference_matrix.T
simulated_MAGs_matrix = pd.read_csv('gene_pa_SP_After_simulation.csv', index_col=0)
simulated_MAGs_matrix = simulated_MAGs_matrix .T
#simulated_MAGs_matrix = simulated_MAGs_matrix.replace(0, pd.NA)
#Empty DataFrames so I can Append the imputed MAGs matrix in them later
imputed_MAGs_matrix = pd.DataFrame()

imputed_MAGs_matrix2 = pd.DataFrame()

imputed_MAGs_matrix3 = pd.DataFrame()

imputed_MAGs_matrix4 = pd.DataFrame()


imputed_MAGs_matrix5 = pd.DataFrame()


imputed_MAGs_matrix6 = pd.DataFrame()

imputed_MAGs_matrix7 = pd.DataFrame()



#convert all 0's to nan in the simulated MAG matrix (nan = unkown if it's 0 or 1)
mask = simulated_MAGs_matrix == 0
simulated_MAGs_matrix[mask] = np.nan



############Simple Imputation###########

for index, row in simulated_MAGs_matrix.iterrows():
    temporary_matrix = pd.concat([reference_matrix, row.to_frame().T])
    #print("Before Simple Imputation")
    #print(temporary_matrix)
    #print(row)
    for column in temporary_matrix.columns:
        #print(column)
        if temporary_matrix[column].isnull().any():
            #most_frequent_value = reference_matrix[column].mode()[0]
            #print(most_frequent_value)
            #imputer = SimpleImputer(strategy='constant', fill_value=most_frequent_value)
            imputer_1 = SimpleImputer(strategy='most_frequent')
            temporary_matrix[column] = imputer_1.fit_transform(temporary_matrix[[column]]).ravel()
    #print("After Imputation")
    #print(temporary_matrix)
    mag_name = index
    imputed_MAGs_matrix = pd.concat([imputed_MAGs_matrix, temporary_matrix.loc[[mag_name]]])
print("Imputed MAGs Matrix Simple Imputation:")
imputed_MAGs_matrix = imputed_MAGs_matrix.astype(int)
print(imputed_MAGs_matrix)


##MultiVariate Imputation##

##############BayesianRidge estimator(Default)#################



estimator=BayesianRidge()


# Concatenate matrices
temporary_matrix2 = pd.concat([reference_matrix, simulated_MAGs_matrix])

# Print the combined matrix
#print("Combined Matrix:")
#print(temporary_matrix2)
bayesian_regressor = BayesianRidge()
iterative_imputer = IterativeImputer(estimator=bayesian_regressor, max_iter=10, random_state=0)

#iterative_imputer.fit(temporary_matrix2)



 
imputed_data = iterative_imputer.fit_transform(temporary_matrix2)

 
imputed_matrix = pd.DataFrame(imputed_data, columns=temporary_matrix2.columns, index=temporary_matrix2.index).round().astype(int)

#print("Combined Matrix after Imputation:")
#print(imputed_matrix)



# Determine the starting index for simulated_MAGs_matrix and extract the rows
start_index = len(reference_matrix)
imputed_simulated_MAGs_matrix2 = imputed_matrix.iloc[start_index:]

 
print("Imputed Simulated MAGs Matrix BayesianRidge estimator:")
print(imputed_simulated_MAGs_matrix2)





################DecisionTreeRegressor###############



regressor = DecisionTreeRegressor(random_state=0)
iterative_imputer = IterativeImputer(
    estimator=regressor,
    max_iter=10,
    imputation_order='roman',
    random_state=0,
)

#iterative_imputer.fit(temporary_matrix2)



 
imputed_data = iterative_imputer.fit_transform(temporary_matrix2)

#for _, _, estimator in iterative_imputer.imputation_sequence_: #to see the tree
 #   print(export_text(estimator))
 
imputed_matrix = pd.DataFrame(imputed_data, columns=temporary_matrix2.columns, index=temporary_matrix2.index).round().astype(int)

#print("Combined Matrix after Imputation:")
#print(imputed_matrix)



 
start_index = len(reference_matrix)
imputed_simulated_MAGs_matrix3 = imputed_matrix.iloc[start_index:]

 
print("Imputed Simulated MAGs Matrix DecisionTreeRegressor:")
print(imputed_simulated_MAGs_matrix3)



###############ExtraTreesRegressor################



import pandas as pd
import numpy as np
from sklearn.ensemble import ExtraTreesRegressor
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer
from sklearn.tree import export_text
 
temporary_matrix2 = pd.concat([reference_matrix, simulated_MAGs_matrix])

#print("Combined Matrix:")
#print(temporary_matrix2)
 
extra_trees_regressor = ExtraTreesRegressor(n_estimators=180, random_state=0, n_jobs=-1)

 
iterative_imputer = IterativeImputer(estimator=extra_trees_regressor, max_iter=10, random_state=0)
 
imputed_data = iterative_imputer.fit_transform(temporary_matrix2)

 
imputed_matrix = pd.DataFrame(imputed_data, columns=temporary_matrix2.columns, index=temporary_matrix2.index).round().astype(int)

#print("Combined Matrix after Imputation:")
#print(imputed_matrix)

 
start_index = len(reference_matrix)
imputed_simulated_MAGs_matrix4 = imputed_matrix.iloc[start_index:]

print("Imputed Simulated MAGs Matrix ExtraTreesRegressor:")
print(imputed_simulated_MAGs_matrix4)


################KNeighborsRegressor###############


# Scale the data

scaler = StandardScaler()
scaled_data = scaler.fit_transform(temporary_matrix2)
#print(scaled_data )
 
knn_regressor = KNeighborsRegressor(n_neighbors=1, weights='uniform')
 
iterative_imputer = IterativeImputer(estimator=knn_regressor, max_iter=150, random_state=0)

# Perform the imputation on scaled data
imputed_scaled_data = iterative_imputer.fit_transform(scaled_data)

# Convert the scaled imputed data back to original scale
imputed_data = scaler.inverse_transform(imputed_scaled_data)
imputed_matrix = pd.DataFrame(imputed_data, columns=temporary_matrix2.columns, index=temporary_matrix2.index).round().astype(int)

#print("Combined Matrix after Imputation KNeighborsRegressor:")
#print(imputed_matrix)
 
start_index = len(reference_matrix)
imputed_simulated_MAGs_matrix5 = imputed_matrix.iloc[start_index:]

print("Imputed Simulated MAGs Matrix KNeighborsRegressor:")
print(imputed_simulated_MAGs_matrix5)




###############################

################KNNImputer###############

###############################



 

df = temporary_matrix2 = pd.concat([reference_matrix, simulated_MAGs_matrix])

# Scale the data
scaler = StandardScaler()
scaled_data = scaler.fit_transform(df)
 
imputer = KNNImputer(n_neighbors=1, weights='distance', metric='nan_euclidean')

# Perform the imputation on scaled data
imputed_scaled_data = imputer.fit_transform(scaled_data)

# Convert the scaled imputed data back to original scale
imputed_data = scaler.inverse_transform(imputed_scaled_data)
imputed_matrix = pd.DataFrame(imputed_data,index=temporary_matrix2.index, columns=df.columns).round().astype(int)

#print("Combined Matrix after Imputation:")
#print(imputed_matrix)

start_index = len(reference_matrix)
imputed_simulated_MAGs_matrix6 = imputed_matrix.iloc[start_index:]
 
print("Imputed Simulated MAGs Matrix KNNImputer:")
print(imputed_simulated_MAGs_matrix6)

###################################################



imputed_MAGs_matrix = imputed_MAGs_matrix
imputed_MAGs_matrix2 =imputed_simulated_MAGs_matrix2
imputed_MAGs_matrix3 =imputed_simulated_MAGs_matrix3
imputed_MAGs_matrix4 =imputed_simulated_MAGs_matrix4
imputed_MAGs_matrix5 =imputed_simulated_MAGs_matrix5
imputed_MAGs_matrix6 =imputed_simulated_MAGs_matrix6











###################################################
################################################################################################################################################################################################################################################################################################################################

#Part2 : Generating the matrice corresponding to each methode in csv format



################################################################################################################################################################################################################################################################################################################################

############Simple Imputation###########
imputed_MAGs_matrix = imputed_MAGs_matrix.T
imputed_MAGs_matrix.to_csv('SimpleImputer_Imatrix.csv', index=True)

##MultiVariate Imputation## using the test 1 : adding each MAG column and imputing
##############BayesianRidge estimator(Default)#################
############Simple Imputation###########
imputed_MAGs_matrix2 = imputed_MAGs_matrix2.T
imputed_MAGs_matrix2.to_csv('BayesianRidge_Imatrix_1.csv', index=True)

################DecisionTreeRegressor###############
############Simple Imputation###########
imputed_MAGs_matrix3 = imputed_MAGs_matrix3.T
imputed_MAGs_matrix3.to_csv('DecisionTreeRegressor_Imatrix_1.csv', index=True)

###############ExtraTreesRegressor################
############Simple Imputation###########
imputed_MAGs_matrix4 = imputed_MAGs_matrix4.T
imputed_MAGs_matrix4.to_csv('ExtraTreesRegressor_Imatrix_1.csv', index=True)

################KNeighborsRegressor###############
############Simple Imputation###########
imputed_MAGs_matrix5 = imputed_MAGs_matrix5.T
imputed_MAGs_matrix5.to_csv('KNeighborsRegressor_Imatrix_1.csv', index=True)




################KNNImputer###############
imputed_MAGs_matrix6 = imputed_MAGs_matrix6.T
imputed_MAGs_matrix6.to_csv('KNNImputer_Imatrix_1.csv', index=True)




