import pandas as pd

def remove_quotes(gene_name):
    # Check if the gene name is a string
    if isinstance(gene_name, str):
        # Remove single quotes from the gene name
        return gene_name.strip("'")
    else:
        # If the gene name is not a string (NaN or null), return it as is
        return gene_name

def remove_comp_from_column_names(node_matrix_file):
    # Read the node matrix from the specified CSV file
    node_df = pd.read_csv(node_matrix_file)
    
    # Modify column names by removing everything after "_comp_"
    node_df.columns = [col.split('_comp_')[0] for col in node_df.columns]
    
    # Apply the remove_quotes function to each element in the first column
    node_df[node_df.columns[0]] = node_df[node_df.columns[0]].apply(remove_quotes)
    
    # Return the updated node matrix DataFrame
    return node_df


# File path for the updated node matrix
node_matrix_file = "/Users/lale/Desktop/Imputation_workflow/scripts/MAGs_querying/queries_data_post_processing/output/The_updated_node_matrix.csv"
output_file = "/Users/lale/Desktop/Imputation_workflow/scripts/MAGs_querying/queries_data_post_processing/output/Pre_updated_node_matrice.csv"

# Remove "_comp_" from column names and quotes from gene names
updated_node_matrix_df = remove_comp_from_column_names(node_matrix_file)


updated_node_matrix_df.to_csv(output_file, index=False)

