#!/usr/bin/env nextflow

nextflow.enable.dsl = 1

/*
 * Nextflow Pipeline to Process Genomes
 * Split dataset into reference and simulation directories and generate input.txt in each directory (the split_genome.py script does that)
 */

params.dataset = "/hps/software/users/jlees/lale/ggCaller_test2/Strategy2_final/EC/bsac_collection_ref"

// Define pipeline process for splitting datasets
process SplitDataset {
    publishDir "results/Run${run_id}", mode: 'copy'
    input:
        val run_id from Channel.of(1, 2, 3)
    output:
        path "Run${run_id}" into splitDirs
    script:
    """
    mkdir -p Run${run_id}
    cd Run${run_id}
    python /hps/software/users/jlees/lale/ggCaller_test2/Nextflow/split_genomes.py ${params.dataset}
    """
}


