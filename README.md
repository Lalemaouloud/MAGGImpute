# MAGGImpute
 A Metagenome annotation workflow with the graph based annotation tool, ggcaller.



![Workflow](workflow/MAGGIMPUTE.png)






1. **Nextflow Process Initialization**:
   - The workflow begins with the dataset being processed by a Nextflow pipeline. This pipeline orchestrates the preprocessing and preparation of the genomic data by splitting the genomes and repeating the whole process for 3 runs.

2. **Initial Gene Calling with ggCaller**:
   - **Dataset Division**: The dataset is divided into two subsets: 25% of the genomes are designated for training, and 75% for simulation.
   - **Gene Calling**: The 25% subset of genomes is processed using ggCaller to perform initial gene calling. This step generates gene graphs and a gene presence/absence matrix for the reference genomes.

3. **Simulation of MAGs**:
   - **Pre-Simulated MAGs**: A set of pre-simulated MAGs is prepared to serve as a ground truth for our benchmark.
   - **Random Completeness Simulation**: MAGs are simulated based on varying levels of completeness to mimic real-world scenarios where MAGs may be incomplete.
   - **Graph Traversal Function**: The updated graph traversal function of ggCaller is employed to match queries from both pre-simulated and post-simulated MAGs to our reference matrix. This function ensures that each gene predicted in the reference sequences is matched to the corresponding sequences in the MAGs, with 80% or more k-mer overlap as the default threshold.

4. **Gene Presence/Absence Matrix Generation**:
   - **Matrix for Reference Genomes**: A gene presence/absence matrix is generated for the reference genomes based on the initial gene calling.
   - **Matrix for Simulated MAGs**: Similarly, a gene presence/absence matrix is created for the simulated MAGs, capturing the gene content across varying levels of completeness.

5. **Imputation of Missing Data**:
   - **Training on 25% Data**: Models are trained on the 25% subset of the original reference data to predict and impute missing gene presence/absence information.
   - **Application of Imputation Methods**: Seven different imputation methods are applied to the simulated MAGs’ gene presence/absence matrix to handle missing features.

6. **Benchmarking and Data Analysis**:
   - **Comparison with Ground Truth**: The imputed MAGs’ matrix is compared against the ground truth matrix to assess the accuracy and effectiveness of the imputation methods.
   - **Analysis and Interpretation**: The results of the imputation and the performance of different methods are analyzed to determine the best approaches for handling incomplete MAG data.

---



![Workflow](workflow/logo.gif)
