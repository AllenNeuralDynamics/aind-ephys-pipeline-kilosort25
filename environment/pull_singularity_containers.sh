#! /bin/bash

if [[ -z $1 ]]; then
    CONTAINER_PATH="/n/holylfs06/LABS/kempner_shared/Everyone/workflow/kilosort25-spike-sorting/containers"
else
    CONTAINER_PATH=$1
fi

for i in `cat task_container_list.txt`; do
    echo $i
    singularity pull --dir $CONTAINER_PATH docker://$i
done