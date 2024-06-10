# AIND Ephys Pipeline with Kilosort2.5
## aind-ephys-pipeline-kilosort25

Electrophysiology analysis pipeline using [Kilosort2.5](https://github.com/MouseLand/Kilosort/tree/v2.5) via [SpikeInterface](https://github.com/SpikeInterface/spikeinterface).

The pipeline is based on [Nextflow](https://www.nextflow.io/) and it includes the following steps:

- [job-dispatch](https://github.com/AllenNeuralDynamics/aind-ephys-job-dispatch/): generates a list of JSON files to be processed in parallel. Parallelization is performed over multiple probes and multiple shanks (e.g., for NP2-4shank probes). The steps from `preprocessing` to `visualization` are run in parallel.
- [preprocessing](https://github.com/AllenNeuralDynamics/aind-ephys-preprocessing/): phase_shift, highpass filter, denoising (bad channel removal + common median reference ("cmr") or highpass spatial filter - "destripe"), and motion estimation (optionally correction)
- [spike sorting](https://github.com/AllenNeuralDynamics/aind-ephys-spikesort-kilosort25/): with Kilosort2.5
- [postprocessing](https://github.com/AllenNeuralDynamics/aind-ephys-postprocessing/): remove duplicate units, compute amplitudes, spike/unit locations, PCA, correlograms, template similarity, template metrics, and quality metrics
- [curation](https://github.com/AllenNeuralDynamics/aind-ephys-curation/): based on ISI violation ratio, presence ratio, and amplitude cutoff
- [unit classification](https://github.com/AllenNeuralDynamics/aind-ephys-unit-classification/): based on pre-trained classifier (noise, MUA, SUA)
- [visualization](https://github.com/AllenNeuralDynamics/aind-ephys-visualization/): timeseries, drift maps, and sorting output in [figurl](https://github.com/flatironinstitute/figurl/blob/main/README.md)
- [result collection](https://github.com/AllenNeuralDynamics/aind-ephys-job-dispatch/): this step collects the output of all parallel jobs and copies the output folders to the results folder
- export to NWB: creates NWB output files. Each file can contain multiple streams (e.g., probes), but only a continuous chunk of data (such as an Open Ephys experiment+recording or an NWB `ElectricalSeries`). This step includes additional sub-steps:
  - [session and subject](https://github.com/AllenNeuralDynamics/NWB_Packaging_Subject_Capsule)
  - [units](https://github.com/AllenNeuralDynamics/NWB_Packaging_Units)


Each step is run in a container and can be deployed on several platforms.

# Local deployment


## Requirements

To deploy locally, you need to install:

- `nextflow`
- `docker`
- `figurl` (optional, for cloud visualization)

Please checkout the [Nextflow](https://www.nextflow.io/docs/latest/install.html) and [Docker](https://docs.docker.com/engine/install/) installation instructions.

To install and configure `figurl`, you need to follow these instructions to setup [`kachery-cloud`]():

1. On your local machine, run `pip install kachery-cloud`
2. Run `kachery-cloud-init`, open the printed URL link and login with your GitHub account
3. Go to `https://kachery-gateway.figurl.org/?zone=default` and create a new Client:
  - Click on the `Client` tab on the left
  - Add a new client (you can choose any label)
4. Set kachery-cloud credentials on your local machine:
  - Click on the newly created client
  - Set the `KACHERY_CLOUD_CLIENT_ID` environment variable to the `Client ID` content
  - Set the `KACHERY_CLOUD_PRIVATE_KEY` environment variable to the `Ptivate Key` content
  - (optional) If using a custom Kachery zone, set `KACHERY_ZONE` environment variable to your zone

By default, `kachery-cloud` will use the `default` zone, which is hosted by the Flatiron institute.
If you plan to use this service extensively, it is recommended to 
[create your own kachery zone](https://github.com/flatironinstitute/kachery-cloud/blob/main/doc/create_kachery_zone.md).


## Run

Clone this repo (`git clone https://github.com/AllenNeuralDynamics/aind-ephys-pipeline-kilosort25.git`) and go to the 
`pipeline` folder. You will find a `main_local.nf`. This nextflow script is accompanied by the 
`nextflow_local.config` and can run on local workstations/machines.

To invoke the pipeline you can run the following command:

```bash
NXF_VER=22.10.8 DATA_PATH=$PWD/../data RESULTS_PATH=$PWD/../results nextflow -C nextflow_local.config run main_local.nf -resume
```

The `DATA_PATH` specifies the folder where the input files are located. 
The `RESULT_PATH` points to the output folder, where the data will be saved.
The `-resume` argument enables the Nextflow caching mechanism

## Additional parameters

Some steps of the pipeline accept additional parameters, that can be passed as follows:

```bash
--{step_name}_args "{args}"
```

The steps that accept additional arguments are:

### `job_dispatch_args`:

```bash
  --concatenate         Whether to concatenate recordings (segments) or not. Default: False
  --input {aind,spikeglx,nwb}
                        Which 'loader' to use. Default 'aind'
```

Currently, the pipeline supports the following input modes:

- `aind`: data ingestion used at AIND. The `DATA_PATH` must contain an `ecephys` subfolder which in turn includes an `ecephys_clipped` (clipped Open Ephys folder) and an `ecephys_compressed` (compressed traces with Zarr). In addition, JSON file following the [aind-data-schema](https://aind-data-schema.readthedocs.io/en/latest/) are parsed to create processing and NWB metadata.
- `spikeglx`: the `DATA_PATH` should contain a SpikeGLX saved folder. It is recommended to add a `subject.json` and a `data_description.json` following the [aind-data-schema](https://aind-data-schema.readthedocs.io/en/latest/) specification, since these metadata are propagated to the NWB files.
- (WIP) `nwb`: the `DATA_PATH` should contain an NWB file (both HDF5 and Zarr backend are supported).

### `preprocess_args`:

```bash
  --debug               Whether to run in DEBUG mode
  --denoising {cmr,destripe}
                        Which denoising strategy to use. Can be 'cmr' or 'destripe'. Default 'cmr'
  --no-remove-out-channels
                        Whether to remove out channels
  --no-remove-bad-channels
                        Whether to remove bad channels
  --max-bad-channel-fraction MAX_BAD_CHANNEL_FRACTION
                        Maximum fraction of bad channels to remove. If more than this fraction, processing is skipped
  --motion {skip,compute,apply}
                        How to deal with motion correction. Can be 'skip', 'compute', or 'apply'. Default 'compute'
  --motion-preset {nonrigid_accurate,kilosort_like,nonrigid_fast_and_accurate}
                        What motion preset to use. Can be 'nonrigid_accurate', 'kilosort_like', or 'nonrigid_fast_and_accurate'. Default "nonrigid_fast_and_accurate"
  --debug-duration DEBUG_DURATION
                        Duration of clipped recording in debug mode. Default is 30 seconds. Only used if debug is enabled
  --n-jobs N_JOBS       Number of jobs to use for parallel processing. Default is -1 (all available cores). It can also be a float between 0 and 1 to use a fraction of available cores
  --params-str PARAMS_STR
                        Optional json string with parameters
```


### `nwb_subject_args`:

```bash
  --backend {hdf5,zarr}
                        NWB backend. It can be either 'hdf5' or 'zarr'. Default 'zarr'

```


# SLURM deployment

To deploy on a SLURM cluster, you need to have access to a SLURM cluster and have the `nextflow` and `singularity` installed.
To use cloud visualizations, follow the same steps descrived in the "Local 
All the 

Then, you can submit the pipeline to the cluster similarly to the Local deplyment, 
but wrapping the command into a script that can be launched with `sbatch`.

Create a script `submit_aind_ephys_pipeline.job` with the following content:

```bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4GB
#SBATCH --partition={your-partition}
#SBATCH --time=24:00:00

conda activate nextflow
PIPELINE_PATH="path-to-your-cloned-repo"
DATA_PATH="path-to-data-folder"
RESULTS_PATH="path-to-results-folder"

PIPELINE_PARAMS={1}

NXF_VER=22.10.8 DATA_PATH=$DATA_PATH RESULTS_PATH=$RESULTS_PATH \\
    nextflow -C $PIPELINE_PATH/pipeline/nextflow_slurm.config run $PIPELINE_PATH/main_slurm.nf -resume
```

# Create a custom layer for data ingestion

The default job-dispatch step only supports loading data 
from AIND folders, SpikeGLX folders, and NWB files.

To ingest other types of data, you can create a similar repo and modify the way that the job list is created 
(see the [job dispatch README](https://github.com/AllenNeuralDynamics/aind-ephys-job-dispatch/blob/main/README.md) for more details).

Then you can create a modified `main_local-slurm.nf` `job_dispatch` process to point to your custom job dispatch repo.