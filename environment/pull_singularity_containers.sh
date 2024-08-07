#! /bin/bash

if [[ -z $EPHYS_CONTAINER_DIR ]]; then
    CONTAINER_DIR="/n/holylfs06/LABS/kempner_shared/Everyone/workflow/kilosort25-spike-sorting/containers"
else
    CONTAINER_DIR=$1
fi

for i in `cat task_container_list.txt`; do
    echo $i
    singularity pull --dir $CONTAINER_DIR docker://$i
done