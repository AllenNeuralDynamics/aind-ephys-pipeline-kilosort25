docker build -t ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:si-0.101.2 -f Dockerfile_base .
docker build -t ghcr.io/allenneuraldynamics/aind-ephys-pipeline-nwb:si-0.101.2 -f Dockerfile_nwb .
docker build -t ghcr.io/allenneuraldynamics/aind-ephys-spikesort-kilosort25:si-0.101.2 -f Dockerfile_kilosort25 .
docker build -t ghcr.io/allenneuraldynamics/aind-ephys-spikesort-kilosort4:si-0.101.2 -f Dockerfile_kilosort4 .
docker build -t ghcr.io/allenneuraldynamics/aind-ephys-spikesort-spykingcircus2:si-0.101.2 -f Dockerfile_spykingcircus2 .
docker build -t ghcr.io/allenneuraldynamics/aind-ephys-unit-classifier:si-0.101.2 -f Dockerfile_unit_classifier .