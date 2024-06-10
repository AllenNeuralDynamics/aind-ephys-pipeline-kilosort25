#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4GB
#SBATCH --partition={your-partition}
#SBATCH --time=2:00:00

# activate the conda environment that has nextflow installed
conda activate env_nf

PIPELINE_PATH="path-to-your-cloned-repo"
DATA_PATH="path-to-data-folder"
RESULTS_PATH="path-to-results-folder"

if [ -z "$1" ]; then
    PIPELINE_PARAMS=""
else
    PIPELINE_PARAMS="$1"
fi

NXF_VER=22.10.8 DATA_PATH=$DATA_PATH RESULTS_PATH=$RESULTS_PATH \\
    nextflow -C $PIPELINE_PATH/pipeline/nextflow_slurm.config run $PIPELINE_PATH/main_slurm.nf $PIPELINE_PARAMS
