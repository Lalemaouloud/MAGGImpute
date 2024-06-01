#!/usr/bin/env python
from Bio import SeqIO
import os
import sys
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt


if len(sys.argv) < 3:
    sys.exit("Usage: python contigPlot.py folderName1 folderName2\nNames of two folders containing genomes should be specified.")

folder_name1 = sys.argv[1]
folder_name2 = sys.argv[2]

output_file1 = "contigLength1.txt"
output_file2 = "contigLength2.txt"

def process_folder(folder_name, output_file):
    with open(output_file, "w") as out:
        # Process each file in the specified directory
        for fasta_file in os.listdir(folder_name):
            if fasta_file.endswith(".fasta") or fasta_file.endswith(".fa"):
                fasta_path = os.path.join(folder_name, fasta_file)
                for record in SeqIO.parse(fasta_path, "fasta"):
                    seq_length = len(record.seq) / 1000  # Convert length from bases to kilobases
                    # Write sequence length and file name without extension
                    out.write(f"{seq_length},{fasta_file[:-6]}\n")


process_folder(folder_name1, output_file1)
process_folder(folder_name2, output_file2)


csv1 = pd.read_csv(output_file1, header=None, names=['Length', 'ID'])
csv2 = pd.read_csv(output_file2, header=None, names=['Length', 'ID'])


csv1['Folder'] = 'Complete genomes'
csv2['Folder'] = 'Simulated MAGs'


combined_csv = pd.concat([csv1, csv2])


sns.set(style="whitegrid")
plt.figure(figsize=(10, 6))
ax = sns.kdeplot(data=combined_csv, x='Length', hue='Folder', fill=True, common_norm=False, palette="crest",
                 linewidth=3, alpha=.5, linestyle="--")
ax.set(xlabel='Contig lengths (Kb)', ylabel='Density')
plt.title('Density Plot of Contig Lengths for Two Folders')
plt.savefig("contigLength_DensityPlot_Combined.png", dpi=600)


#to run the script : specify the names of the 2 folders containing genomes, exemple : python3 contigPlot2.py Bentley_et_al_2006_CPS_sequences simulated_MAGs_for_bentley_all2
