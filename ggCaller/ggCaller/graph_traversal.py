import os
import itertools
import sys
import _pickle as cPickle
from Bio import SeqIO
import networkx as nx
import pandas as pd
def search_graph(graph, graphfile, coloursfile, queryfile, objects_dir, output_dir, query_id, num_threads):
    """
    This is a modified version of the original ggCaller query function
  Searches the ggCaller graph for each MAG listed in the input file,
    matching its sequences against the graph.
    Generate a gene presence/absence Matrix using the information collected from each MAG (each node present a gene. if present-> 1 else ->0)
    """
    if not os.path.exists(objects_dir):
        print("Please specify a ggc_data directory")
        return

    objects_dir = os.path.join(objects_dir, "")
    #panaroo_graph = nx.read_gml('/hps/software/users/jlees/lale/ggCaller_test2/Dataset_3_SP_V2/before/final_graph_references.gml')
    #updated_panaroo_graph = panaroo_graph.copy()
    
    # Reset geneIDs and genomeIDs
    for node, data in updated_panaroo_graph.nodes(data=True):
        if 'geneIDs' in data:
            data['geneIDs'] = []  # Empty geneIDs
        if 'genomeIDs' in data:
            data['genomeIDs'] = []  # Empty genomeIDs

# Indexing now :
    all_genes_IDs=[]
    node_sequences = {}

    # Iterate over each node in the graph
    for node, data in panaroo_graph.nodes(data=True):
        # Ensure the node is in the dictionary with an empty list to start with
        if node not in node_sequences:
            node_sequences[node] = []

        # If 'seqIDs' key is present, extend the list with these IDs
        if 'seqIDs' in data:
            node_sequences[node].extend(data['seqIDs'])

    # Print the resulting dictionary to see the node-sequence mappings
    #print(node_sequences)  # Uncomment this line to see the output in a real environment (useful to debug or understang the data structure here)

    #node_matrix = {}
    node_list = list(node_sequences.keys())
    mag_list = []
    node_matrix_df = pd.DataFrame(index=node_list)
# Iterate over MAG paths listed in the queryfile
    with open(queryfile, "r") as paths_file:
        for mag_path in paths_file:
            mag_path = mag_path.strip()
            if not os.path.exists(mag_path):
                print(f"MAG file not found: {mag_path}")
                continue

            # Read and parse sequences in MAG file
            id_vec = []
            query_vec = []
            fasta_file = False
            with open(mag_path, "r") as f:
                first_line = f.readline()
                if ">" in first_line:
                    fasta_file = True

            if fasta_file:
                fasta_sequences = SeqIO.parse(open(mag_path), 'fasta')
                for entry in fasta_sequences:
                    query_vec.append(str(entry.seq))
                    id_vec.append(str(entry.id))
            else:
                with open(mag_path, "r") as f:
                    for line in f:
                        if line[0] != ">":
                            query_vec.append(line.strip())

            # Read in graph object and high_scoring ORFs and node_index
            graph.data_in(objects_dir + "ggc_graph.dat", graphfile, coloursfile, num_threads)

            # Query the sequences in the graph
            print(f"Querying genes in MAG: {mag_path}...")
            input_colours, kmer, query_nodes = graph.search_graph(query_vec, query_id, num_threads)

            # Parse isolate names
            isolate_names = [os.path.splitext(os.path.basename(x))[0] for x in input_colours]

            with open(objects_dir + "high_scoring_orfs.dat", "rb") as input_file:
                high_scoring_ORFs = cPickle.load(input_file)

            with open(objects_dir + "node_index.dat", "rb") as input_file:
                node_index = cPickle.load(input_file)

            outfile = os.path.join(output_dir, f"matched_queries_{os.path.splitext(os.path.basename(mag_path))[0]}.fasta")
            print(f"Matching overlapping ORFs for MAG: {mag_path}...")
            # Initialize dictionary to store matched ORFs for each MAG
            ORF_dict = {}
            for i in range(len(query_nodes)):
                for node in query_nodes[i]:
                    for ORF_ID in node_index[node]:
                        if ORF_ID not in ORF_dict:
                            ORF_dict[ORF_ID] = []
                        ORF_dict[ORF_ID].append(i)
                        #print(ORF_dict.keys())
                        #geneIDs = ORF_dict.keys()
                        geneIDs = set(ORF_dict.keys())
            #print("geneIDs",geneIDs)
            gene_to_node = {}
            for node, seq_list in node_sequences.items():
                for seq in seq_list:
                    for geneID in geneIDs:
                        if geneID in seq:
                            gene_to_node[geneID] = node
            #print(f"New dictionnary containing each geneID and the corresponding node in the MAG: {mag_path}")
            #print(gene_to_node)
            mag_name = os.path.splitext(os.path.basename(mag_path))[0]
            mag_list.append(mag_name)
            presence = [1 if node in gene_to_node.values() else 0 for node in node_list]
            node_matrix_df[mag_name] = presence
           #all_genesIDs=[] #Uncomment this to update the panaroo graph with the ggc_IDs and genomes really present in each node. but note that this is not really useful because we generate the gene presence/absence here directly from our dictionnary. 
            #all_genes_IDs.extend(geneIDs)
            #for gene_id, node in gene_to_node.items():
             #   if node in updated_panaroo_graph:
              #      if 'geneIDs' in updated_panaroo_graph.nodes[node]:
               #         updated_panaroo_graph.nodes[node]['geneIDs'].append(gene_id)
                #    else:
                 #       updated_panaroo_graph.nodes[node]['geneIDs'] = [gene_id]
               # else:
                #    print(f"Node {node} not found in updated_panaroo_graph.")
            #updated_graph_filename = "/hps/software/users/jlees/lale/ggCaller_test2/Dataset_3_SP_V2/before//The_Finale_updated_panaroo_graph.gml"
            #nx.write_gml(updated_panaroo_graph, updated_graph_filename)
            #print("done updating the graph!!")

    print("Node Matrix DataFrame:")
    print(node_matrix_df)
    output_filename = "node_matrix.csv"
    node_matrix_df.to_csv(output_filename)
    print(f"Node matrix DataFrame written to: {output_filename}")
    #print(node_sequences)
    print("Well done!")
    return

    


