# ggCaller MAGs-Query Function 🧬

## Function Overview
The updated query function for ggCaller is designed to process Metagenome-Assembled Genomes (MAGs) against a pre-constructed graph of reference sequences. This function iterates over each MAG, queries the graph for sequence matches, and compiles a gene presence/absence matrix for each MAG. This matrix indicates whether each gene (represented by a node in the graph) is present (1) or absent (0) in each MAG.

## Function Capabilities 🔍
- **Graph Search**: Iteratively searches the ggCaller graph for each MAG in the input file, matching MAG sequences against the graph.
- **Matrix Generation**: Generates a gene presence/absence matrix using the data collected from each MAG. Each node in the graph representing a gene is marked as present (1) or absent (0) based on the query results.
- **Output Information**: The output contains node IDs with presence or absence markers for each MAG. For a matrix with gene names, users should refer to the data processing instructions provided in the designated folder.

## Function Details 🔧
The function is structured as follows:
- Initializes by checking necessary directories and setting up the environment.
- Reads the graph and prepares a mapping of node sequences.
- Iterates over each MAG path listed in the `queryfile`.
  - For each MAG, sequences are read and queried against the graph.
  - High-scoring ORFs and their corresponding nodes are identified.
  - A presence/absence matrix is updated for each MAG based on the query results.
- Outputs the final node matrix as a CSV file and provides a summary printout of the process.

- Ensure all input files and directories are correctly specified and accessible.
- Adjust the number of threads based on your processing environment to optimize performance.

![Example Image](/src/Screenshot.png "This is an example image")


## How to Execute the Query Function? ⚙️🤔
To run the query function, use the following command with the appropriate arguments:

```bash
ggcaller --query [path/to/input.txt] --graph [path/to/input.gfa] --colours [path/to/input.color.bfg] --data [path/to/ggc_data] --out [output_directory] --threads [number_of_threads]
```


## Command Parameters 📝

### `--query [path/to/input.txt]`
- **Purpose**: Specifies the path to the input file containing a list of MAG paths to be processed.
- **Example**: `--query ./data/MAGs_list.txt`
- **Details**: This file should contain one path per line, each pointing to a MAG file that needs to be queried against the graph.

### `--graph [path/to/input.gfa]`
- **Purpose**: Specifies the path to the graph file in GFA (Graphical Fragment Assembly) format.
- **Example**: `--graph ./graphs/reference_graph.gfa`
- **Details**: This graph represents the reference sequences that the MAGs will be compared against.

### `--colours [path/to/input.color.bfg]`
- **Purpose**: Specifies the path to the colour file associated with the graph.
- **Example**: `--colours ./graphs/reference_colours.bfg`
- **Details**: This file contains colour data that helps in differentiating various sequences in the graph.

### `--data [path/to/ggc_data]`
- **Purpose**: Specifies the directory where ggCaller specific data files are stored when executing with --save mode.
- **Example**: `--data ./ggCaller_data/`
- **Details**: This directory should contain necessary binary data files used by ggCaller for processing queries.

### `--out [output_directory]`
- **Purpose**: Specifies the directory where the output files will be saved.
- **Example**: `--out ./output/results/`
- **Details**: After processing, the gene presence/absence matrix and other outputs will be saved in this directory.

### `--threads [number_of_threads]`
- **Purpose**: Specifies the number of threads to use for processing.
- **Example**: `--threads 4`
- **Details**: Increasing the number of threads may speed up the processing time, depending on the capability of your hardware.


## Troubleshooting 🛠️

**Issue:** Missing files error.
- Solution: Ensure all paths in the command are correct and that all necessary files are in the specified locations.

**Issue:** Performance is slower than expected.
- Solution: Increase the number of threads if your hardware supports it, or check for high system resource usage from other applications.


## FAQs ❓


### Q: What should I do if I get a Python dependency error?
**A**: Ensure all required Python packages are installed. Use `pip install package_name` to install any missing packages. Common packages needed include BioPython and NetworkX, which can be installed using the commands `pip install biopython` and `pip install networkx`, respectively.

### Q: Where can I find more information on interpreting the output matrix?
**A**: Detailed information about interpreting the output matrix can be found in the data processing instructions provided the queries_data_post_processing directory, note that this function output a matrix of each node-ID presence or absence in each MAG. to replace node-IDs with their names read the instructions in the queries_data_post_processing directory.   


### Q: What should I check if the output files are not being generated as expected?
**A**: First, verify that all paths specified in the command are correct and accessible. Check the console output for any error messages that may indicate what went wrong during the execution. Ensure that the `output_directory` has the necessary write permissions and sufficient space to store the generated files.
