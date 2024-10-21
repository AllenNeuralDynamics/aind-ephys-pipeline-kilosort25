docker tag ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:si-0.101.2 ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:latest
docker tag ghcr.io/allenneuraldynamics/aind-ephys-pipeline-nwb:si-0.101.2 ghcr.io/allenneuraldynamics/aind-ephys-pipeline-nwb:latest
docker tag ghcr.io/allenneuraldynamics/aind-ephys-spikesort-kilosort25:latest ghcr.io/allenneuraldynamics/aind-ephys-spikesort-kilosort25:latest
docker tag ghcr.io/allenneuraldynamics/aind-ephys-spikesort-kilosort4:latest ghcr.io/allenneuraldynamics/aind-ephys-spikesort-kilosort4:latest
docker tag ghcr.io/allenneuraldynamics/aind-ephys-spikesort-spykingcircus2:latest ghcr.io/allenneuraldynamics/aind-ephys-spikesort-spykingcircus2:latest
docker tag ghcr.io/allenneuraldynamics/aind-ephys-unit-classifier:latest ghcr.io/allenneuraldynamics/aind-ephys-unit-classifier:latest

docker push --all-tags ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:si-0.101.2 
docker push --all-tags ghcr.io/allenneuraldynamics/aind-ephys-pipeline-nwb:si-0.101.2
docker push --all-tags ghcr.io/allenneuraldynamics/aind-ephys-spikesort-kilosort25:si-0.101.2
docker push --all-tags ghcr.io/allenneuraldynamics/aind-ephys-spikesort-kilosort4:si-0.101.2
docker push --all-tags ghcr.io/allenneuraldynamics/aind-ephys-spikesort-spykingcircus2:si-0.101.2
docker push --all-tags ghcr.io/allenneuraldynamics/aind-ephys-unit-classifier:si-0.101.2