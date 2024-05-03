# MAG Simulation Documentation 📝

This ReadMe file provides an overview of the MAG (Metagenome-Assembled Genome) simulation process using the `remove_sequence.py` script.

## Overview

The MAG simulation process involves generating synthetic incomplete genomes (MAGs) based on a given completeness distribution. These MAGs are created by randomly removing sections from complete genomes, simulating the presence of incomplete genomic data typical in metagenomic studies.

## Prerequisites

- Required Python libraries: argparse, json, pandas, numpy, os, Bio (Biopython)...

## Usage

To execute the MAG simulation, use the following command:

```bash
python3 remove_sequence.py --input /path/to/input/file_paths.txt --dist /path/to/completeness_distribution.txt --prop-complete 0.5 --avg-breaks 2 --outdir /path/to/output/directory
```

Replace /path/to/your/input/file_paths.txt with the path to your file containing the list of genome fasta files to remove sequence from. Each file path should be listed on a separate line.

Replace /path/to/your/completeness_distribution.txt with the path to your file containing the genome completeness distribution for sampling. It must be a single column of floats, one per line.


--prop-complete: Proportion of complete genomes between 0-1. Default is 0.5.
--avg-breaks: Average number of sections to be removed from genomes. Must be >=1. Default is 2.
--outdir: Output directory where the simulated MAGs will be saved. Default is "./simulated_MAGs/".


The simulated MAGs will be saved in the specified output directory. Each simulated MAG will be saved as a fasta file with the completeness level appended to the filename.

Additionally, a completeness file (completeness.tsv) will be generated in the output directory, containing information about each simulated MAG, including filename, completeness level, and sections removed.


Happy MAG simulation! 🌟
