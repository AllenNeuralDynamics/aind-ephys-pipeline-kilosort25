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
- [result collection](https://github.com/AllenNeuralDynamics/aind-ephys-result-collector/): this step collects the output of all parallel jobs and copies the output folders to the results folder
- export to NWB: creates NWB output files. Each file can contain multiple streams (e.g., probes), but only a continuous chunk of data (such as an Open Ephys experiment+recording or an NWB `ElectricalSeries`). This step includes additional sub-steps:
  - [session and subject](https://github.com/AllenNeuralDynamics/NWB_Packaging_Subject_Capsule)
  - [units](https://github.com/AllenNeuralDynamics/NWB_Packaging_Units)

Each step is run in a container and can be deployed on several platforms. 
See the [Local deplyment](#local-deployment) and [SLURM deployment](#slurm-deployment) sections for more details.

# Input

Currently, the pipeline supports the following input data types:

- `aind`: data ingestion used at AIND. The input folder must contain an `ecephys` subfolder which in turn includes an `ecephys_clipped` (clipped Open Ephys folder) and an `ecephys_compressed` (compressed traces with Zarr). In addition, JSON file following the [aind-data-schema](https://aind-data-schema.readthedocs.io/en/latest/) are parsed to create processing and NWB metadata.
- `spikeglx`: the input folder should be a SpikeGLX folder. It is recommended to add a `subject.json` and a `data_description.json` following the [aind-data-schema](https://aind-data-schema.readthedocs.io/en/latest/) specification, since these metadata are propagated to the NWB files.
- (WIP) `nwb`: the input folder should contain a single NWB file (both HDF5 and Zarr backend are supported).

For more information on how to select the input mode and set additional parameters,
see the [Local deployment - Additional parameters](#additional-parameters) section.

# Output

The output of the pipeline is saved to the `RESULTS_PATH`. 
Since the output is produced using SpikeInterface, it is recommended to go through 
[its documentation](https://spikeinterface.readthedocs.io/en/0.100.7/) to understand how to easily 
load and interact with the data:

The output includes the following files and folders:

**`preprocessed`**

This folder contains the output of preprocessing, including preprocessed JSON files associated to each stream and 
motion folders containing the estimated motion.
The preprocessed JSON files can be used to re-instantiate the recordings, provided that the raw data folder is 
mapped to the same location as the input of the pipeline.

In this case, the preprocessed recording can be loaded as a `spikeinterface.BaseRecording` with:
```python
import spikeinterface as si

recording_preprocessed = si.load_extractor("path-to-preprocessed.json", base_folder="path-to-raw-data-parent")
```

The motion folders can be loaded as:
```python
import spikeinterface.preprocessing as spre

motion = spre.load_motion("path-to-motion-folder")
```
They include the `motion`, `temporal_bins`, and `spatial_bins` fields, which can be used to visualize the
estimated motion.

**`spikesorted`**

This folder contains the raw spike sorting outputs from Kilosort2.5 for each stream.

It can be loaded as a `spikeinterface.BaseSorting` with:
```python
import spikeinterface as si

sorting_raw = si.load_extractor("path-to-spikesorted-folder")
```

**`postprocessed`**

This folder contains the output of the post-processing for each stream. It can be loaded as a 
`spikeinterface.WaveformExtractor` with:
```python
import spikeinterface as si

waveform_extractor = si.load_waveforms("path-to-postprocessed-folder", with_recording=False)
```

The `waveform_extractor` includes many computed extensions. This example shows how to load some of them:
```python
unit_locations = we.load_extension("unit_locations").get_data()
# unit_locations is a np.array with the estimated locations

qm = we.load_extension("quality_metrics").get_data()
# qm is a pandas.DataFrame with the computed quality metrics
```

**`curated`**

This folder contains the curated spike sorting outputs, after unit deduplication, quality-metric curation 
and automatic unit classification.

It can be loaded as a `spikeinterface.BaseSorting` with:
```python
import spikeinterface as si

sorting_curated = si.load_extractor("path-to-curated-folder")
```

The `sorting_curated` object contains the following curation properties (which can be retrieved with 
`sorting_curated.get_property(property_name)`):

- `default_qc`: `True` if the unit passes the quality-metric-based curation, `False` otherwise
- `decoder_label`: either `noise`, `MUA` or `SUA`

**`nwb`**

This folder contains the generated NWB files.

**`visualization_output.json`**

This JSON file containes the generated Figurl links for each stream, including a `timeseries` and a `sorting_summary` 
view.

**`processing.json`**

This JSON file logs all the processing steps, parameters, and execution times.

**`nextflow`**

All files generated by Nextflow are saved here


# Parameters

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

- `aind`: data ingestion used at AIND. The `DATA_PATH` must contain an `ecephys` subfolder which in turn includes an `ecephys_clipped` (clipped Open Ephys folder) and an `ecephys_compressed` (compressed traces with Zarr). In addition, JSON file following the [aind-data-schema](https://aind-data-schema.readthedocs.io/en/latest/) are parsed to create processing and NWB metadata.
- `spikeglx`: the `DATA_PATH` should contain a SpikeGLX saved folder. It is recommended to add a `subject.json` and a `data_description.json` following the [aind-data-schema](https://aind-data-schema.readthedocs.io/en/latest/) specification, since these metadata are propagated to the NWB files.
- (WIP) `nwb`: the `DATA_PATH` should contain an NWB file (both HDF5 and Zarr backend are supported).

### `preprocessing_args`:

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
```


### `nwb_subject_args`:

```bash
  --backend {hdf5,zarr}
                        NWB backend. It can be either 'hdf5' or 'zarr'. Default 'zarr'

```


In Nextflow, the The `-resume` argument enables the caching mechanism.


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
NXF_VER=22.10.8 DATA_PATH=$PWD/../data RESULTS_PATH=$PWD/../results \
    nextflow -C nextflow_local.config run main_local.nf \
    -log $RESULTS_PATH/nextflow/nextflow.log \
    --n_jobs 8 -resume
```

The `DATA_PATH` specifies the folder where the input files are located. 
The `RESULT_PATH` points to the output folder, where the data will be saved.
The `--n_jobs` argument specifies the number of parallel jobs to run.

Additional parameters can be passed as described in the [Parameters](#parameters) section.


## Example run command

As an example, here is how to run the pipeline on a SpikeGLX dataset in debug mode 
on a 120-second snippet of the recording with 16 jobs:

```bash
NXF_VER=22.10.8 DATA_PATH=path/to/data_spikeglx RESULTS_PATH=path/to/results_spikeglx \
    nextflow -C nextflow_local.config run main_local.nf --n_jobs 16 \
    --job_dispatch_args "--input spikeglx" --preprocessing_args "--debug --debug-duration 120"
```


# SLURM deployment

To deploy on a SLURM cluster, you need to have access to a SLURM cluster and have the 
[Nextflow](https://www.nextflow.io/docs/latest/install.html) and Singularity/Apptainer installed. 
To use Figurl cloud visualizations, follow the same steps descrived in the 
[Local deployment - Requirements](#requirements) section and set the KACHERY environment variables.

Then, you can submit the pipeline to the cluster similarly to the Local deplyment, 
but wrapping the command into a script that can be launched with `sbatch`.

You can use the `slurm_submit.sh` script as a template to submit the pipeline to your cluster.

```bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4GB
#SBATCH --time=2:00:00
### change {your-partition} to the partition/queue on your cluster
#SBATCH --partition={your-partition}


# modify this section to make the nextflow command available to your environment
# e.g., using a conda environment with nextflow installed
conda activate env_nf

PIPELINE_PATH="path-to-your-cloned-repo"
DATA_PATH="path-to-data-folder"
RESULTS_PATH="path-to-results-folder"
WORKDIR="path-to-large-workdir"

NXF_VER=22.10.8 DATA_PATH=$DATA_PATH RESULTS_PATH=$RESULTS_PATH nextflow \
    -C $PIPELINE_PATH/pipeline/nextflow_slurm.config \
    -log $RESULTS_PATH/nextflow/nextflow.log \
    run $PIPELINE_PATH/pipeline/main_slurm.nf \
    -work-dir $WORKDIR \
    --preprocessing_args "--debug --debug-duration 120" \ # additional parameters
    -resume
```

You should change the `--partition` parameter to match the partition you want to use on your cluster and point to the correct paths and parameters.

Then, you can submit the script to the cluster with:

```bash
sbatch slurm_submit.sh
```


# Create a custom layer for data ingestion

The default job-dispatch step only supports loading data 
from AIND folders, SpikeGLX folders, and NWB files.

To ingest other types of data, you can create a similar repo and modify the way that the job list is created 
(see the [job dispatch README](https://github.com/AllenNeuralDynamics/aind-ephys-job-dispatch/blob/main/README.md) for more details).

Then you can create a modified `main_local-slurm.nf` `job_dispatch` process to point to your custom job dispatch repo.