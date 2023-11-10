# AIND Ephys Pipeline with Kilosort2.5
## aind-ephys-pipeline-kilosort25

Electrophysiology analysis pipeline using [Kilosort2.5](https://github.com/MouseLand/Kilosort/tree/v2.5) via [SpikeInterface](https://github.com/SpikeInterface/spikeinterface).

The pipeline includes:

- preprocessing: phase_shift, highpass filter, and 1. common median reference ("cmr") or 2. destriping (bad channel interpolation + highpass spatial filter - "destripe")
- spike sorting: with pyKilosort
- postprocessing: remove duplicate units, compute amplitudes, spike/unit locations, PCA, correlograms, template similarity, template metrics, and quality metrics
- curation: based on ISI violation ratio, presence ratio, and amplitude cutoff
- visualization: timeseries, drift maps, and sorting output in sortingview