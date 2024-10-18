RESUME_FLAG=""
if [ "$1" == "-resume" ]; then
    RESUME_FLAG="-resume"
fi


NXF_VER=22.10.8 DATA_PATH="$PWD/../sample_dataset/nwb/" RESULTS_PATH="$PWD/../sample_dataset/nwb_results/" \
    nextflow -C nextflow_local.config -log $RESULTS_PATH/nextflow/nextflow.log run main_local.nf \
    --sorter spykingcircus2 --duration 8 --job_dispatch_args "--input nwb" --preprocessing_args "--motion skip" $RESUME_FLAG