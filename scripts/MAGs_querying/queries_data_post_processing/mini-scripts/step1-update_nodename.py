import networkx as nx
import pandas as pd


# Function to load a graph from a GML file and map labels to names
def load_graph_and_map_labels_to_names(filepath):
    # read gml (errors handling)
    try:
        graph = nx.read_gml(filepath)
    except Exception as e:
        return {"error": str(e)}
    label_to_name = {}
    
    # Iterate through each node and its data in the graph and then store in the dict
    for node, data in graph.nodes(data=True):
        if 'CID' in data and 'name' in data:
            label_to_name[data['CID']] = data['name']
    
    return label_to_name

#print(load_graph_and_map_labels_to_names("/Users/lale/Desktop/project/gc/new/final_graph_references.gml"))



# Function to replace labels with names in a node matrix
def replace_labels_with_names(node_matrix_file, label_to_name):

    node_df = pd.read_csv(node_matrix_file, header=None)
    
    # Replace node labels with names
    node_df[0] = node_df[0].map(label_to_name.get)
       # Return the updated node matrix DataFrame
    return node_df
# Function to write a DataFrame to a CSV file
def write_dataframe_to_csv(dataframe, output_file):
 # Write the DataFrame to the specified CSV file without including indices and headers
    dataframe.to_csv(output_file, index=False, header=False)


graph_file = "/Users/lale/Desktop/Imputation_workflow/scripts/MAGs_querying/queries_data_post_processing/final_graph_references.gml"
node_matrix_file = "/Users/lale/Desktop/Imputation_workflow/scripts/MAGs_querying/queries_data_post_processing/node_matrix.csv"
output_file = "/Users/lale/Desktop/Imputation_workflow/scripts/MAGs_querying/queries_data_post_processing/The_updated_node_matrix.csv"


# Load the graph from the GML file and map labels to names
label_to_name = load_graph_and_map_labels_to_names(graph_file)

# Replace labels with names in the node matrix
updated_node_matrix_df = replace_labels_with_names(node_matrix_file, label_to_name)
# Write the updated DataFrame to a CSV file
write_dataframe_to_csv(updated_node_matrix_df, output_file)

print("Done! :)")



                                                                ###


#commende utile pour comparer les outputs dimentions : awk -F, '{print NF; exit}' The_updated_node_matrix.csv | uniq | xargs echo "Rows: $(wc -l < The_updated_node_matrix.csv), Columns: "

