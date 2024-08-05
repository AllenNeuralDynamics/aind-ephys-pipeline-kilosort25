# AIND Ephys Pipeline with Kilosort2.5

## Electrophysiology Analysis with Kilosort2.5 on Kempner's HPC

This document outlines the workflow for performing electrophysiology analysis using Kilosort2.5 on the computational resources provided by Kempner's HPC. This pipeline is a derivative of the one available at https://github.com/AllenNeuralDynamics/aind-ephys-pipeline-kilosort25.

The analysis process consists of several steps, as illustrated in the flowchart: preprocessing, spike sorting, post-processing, and visualization. All these steps are executed through the Nextflow workflow tool. While the pipeline can handle various data formats like aind, nwb, and spikeglx, this guide will focus specifically on spikeglx data.

 

### Preparing Input Data

Transferring Data to the Cluster: Begin by transferring your experimental data to the cluster. Ensure each experiment's data resides in its own dedicated directory. The expected data structure is:

```
data_dir
  input data
```

### Slurm Job file

Copying the Job Script: Locate the relevant job script (spike_sort_slurm.slrm) from the shared directory and copy it to a designated job directory on the cluster. This job directory can be situated within your lab's allocated space.

```
cp  /n/holylfs06/LABS/kempner_shared/Everyone/ephys/software/aind-ephys-pipeline-kilosort25/pipeline/spike_sort_slurm.slrm .
```

Alternative - Cloning the Repository (Optional): If preferred, you can clone the entire Git repository containing the pipeline and edit the Slurm job file:

```
/n/holylabs/LABS/kempner_dev/Lab/projects/ephys/aind-ephys-pipeline-kilosort25/pipeline
```

### Setting Up Directory Paths

Several crucial environment variables need modification within the spike_sort_slurm.slrm script:

- DATA_PATH: Specifies the location of your input data.
- RESULTS_PATH: Defines where the pipeline will store the generated output files.
- WORK_DIR: A temporary directory used by the pipeline during execution. It's recommended to utilize the scratch storage for this purpose.


#### Modifying Slurm Job Options

Within the job script, ensure you provide the appropriate partition and account names for your allocation on the HPC system. Here's an example:



In the job file, provide the correct partition and account names. 

```
#SBATCH --partition=<PARTITION_NAME>
#SBATCH --account=<ACCOUNT_NAME>
```

#### Submitting the Job

Once you've made the necessary adjustments, submit the job script using the sbatch command:



```
sbatch spike_sort_slurm.slrm
```

### Monitoring Job Status

To track the progress of your submitted job, use the squeue command with your username:

```
squeue -u <username>
```
Obtaining Results

Upon successful job completion, the output directory will contain various files:

```
curated/               postprocessed/  processing.json  visualization_output.json
data_description.json  preprocessed/   spikesorted/
```

The visualization_output.json file provides visualizations of timeseries, drift maps, and the sorting output using Figurl. You can refer to the provided sample visualization for reference.


[sorting_summary](https://figurl.org/f?v=npm://@fi-sci/figurl-sortingview@12/dist&d=sha1://3b0465d83dab9c14210477b5bc690c94c2f0c797&s={%22sortingCuration%22:%22gh://AllenNeuralDynamics/ephys-sorting-manual-curation/main/ecephys_session/block0_imec0.ap_recording1_group1/kilosort2_5/curation.json%22}&label=ecephys_session%20-%20block0_imec0.ap_recording1_group1%20-%20kilosort2_5%20-%20Sorting%20Summary)

[timeseries](https://figurl.org/f?v=npm://@fi-sci/figurl-sortingview@12/dist&d=sha1://f038c09c3465a22bda53e6917e1cfa7ad0afd6f7&label=ecephys_session%20-%20block0_imec0.ap_recording1_group0)


### Further Analysis and Manual Curation

For manual curation and annotation of your data, you can leverage the Jupyter notebook available as Spikeinterface.ipynb.

Manual curation and annotation can be done with the help of Jupyter notebook available in `Spikeinterface.ipynb`. 



### More details about the pipeline 

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

