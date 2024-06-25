To test the pipeline, go to 
```
/n/holylabs/LABS/kempner_dev/Lab/projects/ephys/aind-ephys-pipeline-kilosort25/pipeline
```
and change the Slurm and job parameters in the file `submit_nwb.slrm`. 

Here are the important environmental variables that need to be changed. 

- DATA_PATH
- RESULTS_PATH
- WORKDIR

Currently, the pipeline is tested to run on NWB data format. We will add more options in the future. 

Note that the execution of the pipeline requires nextflow installation. Before executing the pipeline, make sure to instantiate the software environment as follows
```
module load Mambaforge/23.11.0-fasrc01
mamba activate /n/holylabs/LABS/kempner_dev/Lab/software/nextflow_conda
```


