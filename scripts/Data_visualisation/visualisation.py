##metrics visualisation 


##Author : LM



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


filled_simulated_MAGs ="CF_SVD_1.csv"

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.colors import ListedColormap

def calculate_metrics(reference_matrix, simulated_MAGs_matrix):
    simulated_MAGs_matrix = pd.read_csv('mags.csv', index_col=0)
    simulated_MAGs_matrix = simulated_MAGs_matrix .T
    # Initialize counts
    TP = 0
    TN = 0
    FP = 0
    FN = 0

 
    result_matrix = np.zeros(reference_matrix.shape)
 
    for i in range(len(reference_matrix.index)):
        for j in range(len(reference_matrix.columns)):
            if reference_matrix.iloc[i, j] == 1 and simulated_MAGs_matrix.iloc[i, j] == 1:
                TP += 1
                result_matrix[i, j] = 1  # TP
            elif reference_matrix.iloc[i, j] == 0 and simulated_MAGs_matrix.iloc[i, j] == 0:
                TN += 1
                result_matrix[i, j] = 2  # TN
            elif reference_matrix.iloc[i, j] == 0 and simulated_MAGs_matrix.iloc[i, j] == 1:
                FP += 1
                result_matrix[i, j] = 3  # FP
            elif reference_matrix.iloc[i, j] == 1 and simulated_MAGs_matrix.iloc[i, j] == 0:
                FN += 1
                result_matrix[i, j] = 4  # FN

    return TP, TN, FP, FN, result_matrix
    
    
    
    
    
    
####################################################

TP1, TN1, FP1, FN1, result_matrix_1 = calculate_metrics(reference_matrix, filled_simulated_MAGs)

result_matrix_1  = pd.DataFrame(result_matrix_1 ,index=simulated_MAGs_matrix.index,
                                 columns=simulated_MAGs_matrix.columns)
                                 

import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

def visualize_matrix(result_matrix, name, filename):
    fig = plt.figure()
    gs = gridspec.GridSpec(1, 3, width_ratios=[5, 5, 1])

    ax1 = fig.add_subplot(gs[0, :-1])
    cmap = 'RdGy'
    im1 = ax1.imshow(result_matrix, cmap=cmap, interpolation='nearest')

    ax1.set_xticks(range(len(result_matrix.columns)))
    ax1.set_yticks(range(len(result_matrix.index)))
    ax1.set_xticklabels([''] * len(result_matrix.columns))
    ax1.set_yticklabels([''] * len(result_matrix.index))

    cax = fig.add_subplot(gs[0, -1])  # Span all rows, last column
    cbar = plt.colorbar(im1, cax=cax, ticks=[1, 2, 3, 4], fraction=0.046, pad=0.04)
    cbar.set_ticklabels(['TP', 'TN', 'FP', 'FN'])

    ax1.set_title(label=name, fontsize=10, color="black", fontweight=25, pad='6.0', fontstyle='italic')
    ax1.set_xlabel('Genes')
    ax1.set_ylabel('MAGs')

    plt.savefig(filename, format='svg')
    plt.show()

name1 = "CF_SVD1"
filename1 = "CF_SVD1_confusions_matrix.svg"

visualize_matrix(result_matrix_1, name1, filename1)
