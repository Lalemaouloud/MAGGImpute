#to run the script : python split_genomes.py path_to_your_source_directory
#example : python3 split_genomes.py /Users/lale/Desktop/Imputation_workflow/scripts/Strategy_2/Bentley_et_al_2006_CPS_sequences
#Author : LM 
#This script will randomly pick files, copy 25% into the reference_files directory, 
#and the remaining 75% into the for_simulation_files directory. 

import os
import shutil
import random
import argparse

def distribute_files(source_dir, reference_ratio=0.25):
    # Determine paths for the new directories in the current directory
    reference_dir = os.path.join(os.getcwd(), 'reference_files')
    simulation_dir = os.path.join(os.getcwd(), 'for_simulation_files')
    
    # Check if the source directory exists
    if not os.path.exists(source_dir):
        raise ValueError(f"The source directory {source_dir} does not exist.")
    
    # Create the target directories if they do not exist
    os.makedirs(reference_dir, exist_ok=True)
    os.makedirs(simulation_dir, exist_ok=True)
    
    # List all files in the source directory
    files = [f for f in os.listdir(source_dir) if os.path.isfile(os.path.join(source_dir, f))]
    
    # Shuffle the files to ensure randomness
    random.shuffle(files)
    
    # Calculate the number of files to distribute to the reference directory
    reference_count = int(len(files) * reference_ratio)
    
    # Distribute files
    for i, file in enumerate(files):
        target_dir = reference_dir if i < reference_count else simulation_dir
        shutil.copy2(os.path.join(source_dir, file), os.path.join(target_dir, file))

def main():
    parser = argparse.ArgumentParser(description='Distribute files into two directories.')
    parser.add_argument('source_dir', type=str, help='Path to the source directory containing files to distribute.')
    
    args = parser.parse_args()
    
    distribute_files(args.source_dir)

if __name__ == '__main__':
    main()
