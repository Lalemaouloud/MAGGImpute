import pandas as pd

# This script reads two CSV files containing matrices, then reorganizes the second matrix according to the order of the first matrix's index. It finally prints and saves the reorganized matrix into a new CSV file.
matrice1 = pd.read_csv('gene_pa_SP_Before_simulation.csv', index_col=0)
print(matrice1)
matrice2 = pd.read_csv('Pre_updated_node_matrice.csv', index_col=0)
print(matrice2)



ordre = matrice1.index.tolist()

matrice2_reorganisee = matrice2.loc[ordre]
print(matrice2_reorganisee)

matrice2_reorganisee.to_csv("Final_updated_node_matrice.csv")


