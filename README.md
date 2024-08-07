
# Neuropixel Ephys Spike Sorting Pipeline on Kempner AI Cluster

This document outlines the workflow for performing spike sorting on electrophysiological recorded data using Kilosort2.5 method on Kempner AI cluster. This pipeline is a derivative of the one available at [Allen Neural Dynamics GitHub]( https://github.com/AllenNeuralDynamics/aind-ephys-pipeline-kilosort25).

The analysis consists of several steps, as illustrated in the flowchart:
- Preprocessing
- Spike sorting
- Post-processing
- Visualization.

All these steps are executed through the Nextflow workflow tool. While the pipeline can handle various data formats like `aind`, `nwb`, and `SpikeGLX`, this guide will focus specifically on `SpikeGLX` data.

<p align="center">
  <img src="https://raw.githubusercontent.com/KempnerInstitute/kilosort25-spike-sorting/main/figures/svg/flowchart_ephys_kilosort2.5_spikesorting.svg " width="60%" />
</p>

## Slurm Job Submission

These are are major steps to run the nextflow pipeline on the Kempner AI 
Cluster.

1. Prepare input data
2. Obtain the pipeline and Slurm scripts
3. Edit the scripts and config files
4. Submit the Slurm job
5. Results and visualization
6. Further Analysis

### 0. Environment Setup

For users running on the cannon cluster, we have cached the containers required for the workflow in a shared directory. For external users, you can use the `environment/pull_singularity_containers.sh` script to pull local copies of 
the required containers to a location of your choice. The alternative path can then be passed to the nextflow execution script through setting the environment variable `EPHYS_CONTAINER_DIR` to point to that directory.

### 1. Preparing Input Data

Begin by transferring your experimental data to the cluster. Ensure each experiment's data resides in its own dedicated directory. The expected data structure is:

```
data_dir
└── 20240805_M100_4W50_g0_imec0
    ├── 20240805_M100_4W50_g0_t0.imec0.ap.bin
    └── 20240805_M100_4W50_g0_t0.imec0.ap.meta

```

###2. Copy the Workfow and Job Files

Clone the repository on the cluster. 

```
git clone https://github.com/KempnerInstitute/kilosort25-spike-sorting

```

### 3. Edit the Job and Config Files

The relevant job and config files are located in the directory `pipeline`. 

```
cd kilosort25-spike-sorting/pipeline
```

Before submitting the job, the Slurm job file `spike_sort_slurm.slrm` and the nextflow configuration file `nextflow_slurm.config` need to be edited to specify the relevant directory paths and cluster resources. 

#### 3.a Setting Up Directory Paths

The following environment variables need modification within the `spike_sort_slurm.slrm` script:

- **DATA_PATH**: Specifies the location of your input data.
- **RESULTS_PATH**: Defines where the pipeline will store the generated output files.
- **WORK_DIR**: A temporary directory used by the pipeline during execution. It's recommended to utilize the scratch storage for this purpose.


#### 3.b Modifying Slurm Job Options

Within the job script, ensure you provide the appropriate partition and account names for your allocation on the Kempner AI cluster. 

```
#SBATCH --partition=<partition_name>
#SBATCH --account=<account_name>
```

In addition, change the clusterOptions in **nextflow_slurm.config** 

```
clusterOptions = ' -p <partition_name> -A <account_name> --constraint=intel'
```
The nextflow will start all the processes (slurm jobs) in the above parition and account. Without any field in the clusterOptions, the job will utilize the default partition and account. Each process uses the resources set in the file `main_slurm.nf`. The constraint `intel` will restrict the job to run on the intel cpus. 

The following lines in the Slurm script define the software environment required to run the job: 
```
module load Mambaforge/23.11.0-fasrc01
module load matlab/R2022b-fasrc01
mamba activate /n/holylfs06/LABS/kempner_shared/Everyone/ephys/software/nextflow_conda
```
It is okay to use the nextflow package in the above path. Alternatively, the nextflow package can be installed in the local directory. 


### 4. Submitting the Job

Once you've made the necessary adjustments, submit the job script using the sbatch command:

```
sbatch spike_sort_slurm.slrm
```

To track the progress of your submitted job, use the squeue command with your username:

```
squeue -u <username>
```


### 5. Results and Visualization

Upon successful job completion, the output directory will contain various files:

```
curated/               postprocessed/  processing.json  visualization_output.json
data_description.json  preprocessed/   spikesorted/
```


The visualization_output.json file provides visualizations of timeseries, drift maps, and the sorting output using Figurl. You can refer to the provided sample visualization for reference.


[sorting_summary](https://figurl.org/f?v=npm://@fi-sci/figurl-sortingview@12/dist&d=sha1://3b0465d83dab9c14210477b5bc690c94c2f0c797&s={%22sortingCuration%22:%22gh://AllenNeuralDynamics/ephys-sorting-manual-curation/main/ecephys_session/block0_imec0.ap_recording1_group1/kilosort2_5/curation.json%22}&label=ecephys_session%20-%20block0_imec0.ap_recording1_group1%20-%20kilosort2_5%20-%20Sorting%20Summary): spike sorting results for visualization and curation

[timeseries](https://figurl.org/f?v=npm://@fi-sci/figurl-sortingview@12/dist&d=sha1://f038c09c3465a22bda53e6917e1cfa7ad0afd6f7&label=ecephys_session%20-%20block0_imec0.ap_recording1_group0): Time series results of sorted spikes. 


### 6. Further Analysis and Manual Curation

For manual curation and annotation of your data, you can leverage the Jupyter notebook available as `spike_interface.ipynb` that is available inside the directory postprocess. 

```
postprocess/spike_interface.ipynb
```

#### Additional Pipeline Arguments

These are the job arguments you can tune for a given job. 
```
job_dispatch_args: 
 --concatenate  
 --input {aind,spikeglx,nwb}

preprocessing_args: 
 --denoising {cmr,destripe} 
 --no-remove-out-channels 
 --no-remove-bad-channels 
 --max-bad-channel-fraction  
 --motion {skip,compute,apply} 
 --motion-preset
```

### Further details on the pipeline and the links to repositories

Electrophysiology analysis pipeline using [Kilosort2.5](https://github.com/MouseLand/Kilosort/tree/v2.5) via [SpikeInterface](https://github.com/SpikeInterface/spikeinterface).

The pipeline is based on [Nextflow](https://www.nextflow.io/) and it includes the following steps:

- [job-dispatch](https://github.com/AllenNeuralDynamics/aind-ephys-job-dispatch/): generates a list of JSON files to be processed in parallel. Parallelization is performed over multiple probes and multiple shanks (e.g., for NP2-4shank probes). The steps from `preprocessing` to `visualization` are run in parallel.
- [preprocessing](https://github.com/AllenNeuralDynamics/aind-ephys-preprocessing/): phase_shift, highpass filter, denoising (bad channel removal + common median reference ("cmr") or highpass spatial filter - "destripe"), and motion estimation (optionally correction)
- [spike sorting](https://github.com/AllenNeuralDynamics/aind-ephys-spikesort-kilosort25/): with Kilosort2.5
- [postprocessing](https://github.com/AllenNeuralDynamics/aind-ephys-postprocessing/): remove duplicate units, compute amplitudes, spike/unit locations, PCA, correlograms, template similarity, template metrics, and quality metrics
- [curation](https://github.com/AllenNeuralDynamics/aind-ephys-curation/): based on ISI violation ratio, presence ratio, and amplitude cutoff
- [unit classification](https://github.com/AllenNeuralDynamics/aind-ephys-unit-classification/): based on pre-trained classifier (noise, MUA, SUA)
- [visualization](https://github.com/AllenNeuralDynamics/aind-ephys-visualization/): timeseries, drift maps, and sorting output in [figurl](https://github.com/flatironinstitute/figurl/blob/main/README.md)
- [result collection](https://github.com/AllenNeuralDynamics/aind-ephys-result-collector/): this step collects the output of all parallel jobs and copies the output folders to the results folder
- export to NWB: creates NWB output files. Each file can contain multiple streams (e.g., probes), but only a continuous chunk of data (such as an Open Ephys experiment+recording or an NWB `ElectricalSeries`). This step includes additional sub-steps:
  - [session and subject](https://github.com/AllenNeuralDynamics/NWB_Packaging_Subject_Capsule)
  - [units](https://github.com/AllenNeuralDynamics/NWB_Packaging_Units)

