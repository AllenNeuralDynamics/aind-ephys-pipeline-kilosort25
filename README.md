# AIND Ephys Pipeline with Kilosort2.5
## aind-ephys-pipeline-kilosort25

Electrophysiology analysis pipeline using [Kilosort2.5](https://github.com/MouseLand/Kilosort/tree/v2.5) via [SpikeInterface](https://github.com/SpikeInterface/spikeinterface).

The pipeline includes:

- preprocessing: phase_shift, highpass filter, denoising (bad channel removal + common median reference ("cmr") or highpass spatial filter - "destripe"), and motion estimation (optionally correction)
- spike sorting: with Kilosort2.5
- postprocessing: remove duplicate units, compute amplitudes, spike/unit locations, PCA, correlograms, template similarity, template metrics, and quality metrics
- curation: based on ISI violation ratio, presence ratio, and amplitude cutoff
- unit classification based on pre-trained classifier (noise, MUA, SUA)
- visualization: timeseries, drift maps, and sorting output in sortingview
- export session, subject, and units data to NWB


# Local deployment

`NXF_VER=22.10.8 DATA_PATH=$PWD/../data  nextflow -C nextflow_local.config run main_local.nf --capsule_aind_ephys_preprocessing_1_args "--debug"`
