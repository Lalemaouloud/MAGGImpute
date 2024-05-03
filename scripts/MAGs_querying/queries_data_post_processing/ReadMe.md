# Data Processing Instructions📊

## Overview 📝
This directory contains the necessary steps to process the raw matrix generated from the ggCaller query function. This matrix outlines the presence or absence of node IDs in each MAG. Our goal is to transform this raw data into a gene presence/absence matrix that is more meaningful for biological analysis.

## Processing Steps 🔧

### Step 1: Update Node Names
- **Script**: `step1-update_nodename.py`
- **Functionality**: This script updates each node ID in our matrix with the actual gene name.


### Step 2: Remove Quotes
- **Script**:  step2-remove_quotes.py
- **Functionality** This script processes the MAGs names and gene names to ensure they are in the correct format, specifically removing unnecessary quotes that might have been added during earlier data handling steps.

### Step 3: Order Rows
- **Script**: step3_Order_Rows.py
- **Functionality**  This script reorganizes the matrix according to the order of the reference matrix's index, ensuring consistency with established reference datasets.

- Modifying Scripts 🛠️ ❗️: Adjust the input and output paths based on where your files are located. You are encouraged to modify the scripts to suit your specific needs. 

### Final Output of the Step 3 🏁

The final output will be a gene presence/absence matrix, formatted and ready to be compared with the gene presence/absence matrix before simulation.
