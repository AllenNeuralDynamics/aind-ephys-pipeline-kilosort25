#!/usr/bin/env nextflow
nextflow.enable.dsl = 1

params.ecephys_path = DATA_PATH

println "DATA_PATH: ${DATA_PATH}"
println "RESULTS_PATH: ${RESULTS_PATH}"
println "PARAMS: ${params}"

// TODO: Allocate time based on recording duration

params_keys = params.keySet()
// set sorter
if ("sorter" in params_keys) {
	sorter = params.sorter
}
else
{
	sorter = "kilosort25"
}
println "Using SORTER: ${sorter}"

if (!params_keys.contains('job_dispatch_args')) {
	params.job_dispatch_args = ""
}
if (!params_keys.contains('preprocessing_args')) {
	params.preprocessing_args = ""
}
if (!params_keys.contains('spikesorting_args')) {
	params.spikesorting_args = ""
}
if (!params_keys.contains('postprocessing_args')) {
	params.postprocessing_args = ""
}
if (!params_keys.contains('nwb_subject_args')) {
	params.nwb_subject_args = ""
}
if (!params_keys.contains('nwb_ecephys_args')) {
	params.nwb_ecephys_args = ""
}


job_dispatch_to_preprocessing = channel.create()
ecephys_to_preprocessing = channel.fromPath(params.ecephys_path + "/", type: 'any')
postprocessing_to_curation = channel.create()
ecephys_to_job_dispatch = channel.fromPath(params.ecephys_path + "/", type: 'any')
ecephys_to_postprocessing = channel.fromPath(params.ecephys_path + "/", type: 'any')
spikesort_kilosort25_to_postprocessing = channel.create()
spikesort_kilosort4_to_postprocessing = channel.create()
spikesort_spykingcircus2_to_postprocessing = channel.create()
preprocessing_to_postprocessing = channel.create()
job_dispatch_to_postprocessing = channel.create()
job_dispatch_to_visualization = channel.create()
unit_classifier_to_visualization = channel.create()
preprocessing_to_visualization = channel.create()
curation_to_visualization = channel.create()
spikesort_kilosort25_to_visualization = channel.create()
spikesort_kilosort4_to_visualization = channel.create()
spikesort_spykingcircus2_to_visualization = channel.create()
postprocessing_to_visualization = channel.create()
ecephys_to_visualization = channel.fromPath(params.ecephys_path + "/", type: 'any')
preprocessing_to_spikesort_kilosort25 = channel.create()
preprocessing_to_spikesort_kilosort4 = channel.create()
preprocessing_to_spikesort_spykingcircus2 = channel.create()
postprocessing_to_unit_classifier = channel.create()
job_dispatch_to_results_collector = channel.create()
preprocessing_to_results_collector = channel.create()
spikesort_kilosort25_to_results_collector = channel.create()
spikesort_kilosort4_to_results_collector = channel.create()
spikesort_spykingcircus2_to_results_collector = channel.create()
postprocessing_to_results_collector = channel.create()
curation_to_results_collector = channel.create()
unit_classifier_to_results_collector = channel.create()
visualization_to_results_collector = channel.create()
ecephys_to_collect_results = channel.fromPath(params.ecephys_path + "/", type: 'any')
ecephys_to_nwb_subject = channel.fromPath(params.ecephys_path + "/", type: 'any')
job_dispatch_to_nwb_units = channel.create()
nwb_ecephys_to_nwb_units = channel.create()
results_collector_to_nwb_units = channel.create()
ecephys_to_nwb_units = channel.fromPath(params.ecephys_path + "/", type: 'any')
job_dispatch_to_nwb_ecephys = channel.create()
ecephys_to_nwb_ecephys = channel.fromPath(params.ecephys_path + "/", type: 'any')
nwb_subject_to_nwb_ecephys = channel.create()

if (sorter == 'kilosort25') {
	spikesort_to_postprocessing = spikesort_kilosort25_to_postprocessing
	spikesort_to_visualization = spikesort_kilosort25_to_visualization
	spikesort_to_results_collector = spikesort_kilosort25_to_results_collector
}
else if (sorter == 'kilosort4') {
	spikesort_to_postprocessing = spikesort_kilosort4_to_postprocessing
	spikesort_to_visualization = spikesort_kilosort4_to_visualization
	spikesort_to_results_collector = spikesort_kilosort4_to_results_collector
}
else if (sorter == 'spykingcircus2') {
	spikesort_to_postprocessing = spikesort_spykingcircus2_to_postprocessing
	spikesort_to_visualization = spikesort_spykingcircus2_to_visualization
	spikesort_to_results_collector = spikesort_spykingcircus2_to_results_collector
}


// capsule - Job Dispatch Ecephys
process job_dispatch {
	tag 'job-dispatch'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:si-0.101.2'

	cpus 4
	memory '32 GB'
	time '1h'

	input:
	path 'capsule/data/ecephys_session' from ecephys_to_job_dispatch.collect()

	output:
	path 'capsule/results/*' into job_dispatch_to_preprocessing
	path 'capsule/results/*' into job_dispatch_to_postprocessing
	path 'capsule/results/*' into job_dispatch_to_visualization
	path 'capsule/results/*' into job_dispatch_to_results_collector
	path 'capsule/results/*' into job_dispatch_to_nwb_ecephys
	path 'capsule/results/*' into job_dispatch_to_nwb_units
	env max_duration_min

	script:
	"""
	#!/usr/bin/env bash
	set -e

	TASK_DIR=\$(pwd)

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-job-dispatch.git" capsule-repo
	git -C capsule-repo checkout f13f3baaec0cabfada060d8860a4056dbcd656b8 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.job_dispatch_args}

	max_duration_min=\$(python get_max_recording_duration_min.py)
	echo "Max recording duration in minutes: \$max_duration_min"

	cd \$TASK_DIR

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Preprocess Ecephys
process preprocessing {
	tag 'preprocessing'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:si-0.101.2'

	cpus 16
	memory '64 GB'
	// Allocate 4h per recording hour
	time { max_duration_min.value.toFloat()/60*4 + 'h' }

	input:
	env max_duration_min
	path 'capsule/data/' from job_dispatch_to_preprocessing.flatten()
	path 'capsule/data/ecephys_session' from ecephys_to_preprocessing.collect()

	output:
	path 'capsule/results/*' into preprocessing_to_postprocessing
	path 'capsule/results/*' into preprocessing_to_visualization
	path 'capsule/results/*' into preprocessing_to_spikesort_kilosort25
	path 'capsule/results/*' into preprocessing_to_spikesort_kilosort4
	path 'capsule/results/*' into preprocessing_to_spikesort_spykingcircus2
	path 'capsule/results/*' into preprocessing_to_results_collector

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	echo "Allocated time: ${task.time}"
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-preprocessing.git" capsule-repo
	git -C capsule-repo checkout 8b993d495e6230b6b2aabfd4acff364679e864b8 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] allocated time: ${task.time}"

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.preprocessing_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Spikesort Kilosort2.5 Ecephys
process spikesort_kilosort25 {
	tag 'spikesort-kilosort25'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-spikesort-kilosort25:si-0.101.2'
	containerOptions '--nv'
	clusterOptions '--gres=gpu:1'
	module 'cuda'

	cpus 16
	memory '64 GB'
	// Allocate 4h per recording hour
	time { max_duration_min.value.toFloat()/60*4 + 'h' }

	input:
	env max_duration_min
	path 'capsule/data/' from preprocessing_to_spikesort_kilosort25

	output:
	path 'capsule/results/*' into spikesort_kilosort25_to_postprocessing
	path 'capsule/results/*' into spikesort_kilosort25_to_visualization
	path 'capsule/results/*' into spikesort_kilosort25_to_results_collector

	when:
	sorter == 'kilosort25'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-spikesort-kilosort25.git" capsule-repo
	git -C capsule-repo checkout 8ad5241757e02effa84a05c5022b17cde01eadff --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] allocated time: ${task.time}"

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.spikesorting_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Spikesort Kilosort4 Ecephys
process spikesort_kilosort4 {
	tag 'spikesort-kilosort4'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-spikesort-kilosort4:si-0.101.2'
	containerOptions '--nv'
	clusterOptions '--gres=gpu:1'
	module 'cuda'

	cpus 16
	memory '64 GB'
	// Allocate 4h per recording hour
	time { max_duration_min.value.toFloat()/60*4 + 'h' }

	input:
	env max_duration_min
	path 'capsule/data/' from preprocessing_to_spikesort_kilosort4

	output:
	path 'capsule/results/*' into spikesort_kilosort4_to_postprocessing
	path 'capsule/results/*' into spikesort_kilosort4_to_visualization
	path 'capsule/results/*' into spikesort_kilosort4_to_results_collector

	when:
	sorter == 'kilosort4'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-spikesort-kilosort4.git" capsule-repo
	git -C capsule-repo checkout 950c137cc9a9ee612dd40a909df7ba781db3db0c --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] allocated time: ${task.time}"

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.spikesorting_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Spikesort SpykingCircus Ecephys
process spikesort_spykingcircus2 {
	tag 'spikesort-spykingcircus2'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-spikesort-spykingcircus2:si-0.101.2'
	containerOptions '--shm-size 1g'

	cpus 16
	memory '64 GB'
	// Allocate 4h per recording hour
	time { max_duration_min.value.toFloat()/60*4 + 'h' }

	input:
	env max_duration_min
	path 'capsule/data/' from preprocessing_to_spikesort_spykingcircus2

	output:
	path 'capsule/results/*' into spikesort_spykingcircus2_to_postprocessing
	path 'capsule/results/*' into spikesort_spykingcircus2_to_visualization
	path 'capsule/results/*' into spikesort_spykingcircus2_to_results_collector

	when:
	sorter == 'spykingcircus2'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-spikesort-spykingcircus2.git" capsule-repo
	git -C capsule-repo checkout 6f4ea112127d1727ba81040cf1563bcf9a40ca7d --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] allocated time: ${task.time}"

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.spikesorting_args}

	echo "[${task.tag}] completed!"
	"""
}


// capsule - Postprocess Ecephys
process postprocessing {
	tag 'postprocessing'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:si-0.101.2'
	containerOptions '--shm-size 1g'

	cpus 16
	memory '64 GB'
	// Allocate 4h per recording hour
	time { max_duration_min.value.toFloat()/60*4 + 'h' }

	input:
	env max_duration_min
	path 'capsule/data/ecephys_session' from ecephys_to_postprocessing.collect()
	path 'capsule/data/' from spikesort_to_postprocessing.collect()
	path 'capsule/data/' from preprocessing_to_postprocessing.collect()
	path 'capsule/data/' from job_dispatch_to_postprocessing.flatten()

	output:
	path 'capsule/results/*' into postprocessing_to_curation
	path 'capsule/results/*' into postprocessing_to_visualization
	path 'capsule/results/*' into postprocessing_to_unit_classifier
	path 'capsule/results/*' into postprocessing_to_results_collector

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-postprocessing.git" capsule-repo
	git -C capsule-repo checkout dd9b22b82a37753a7e16daad89fe5b2b16c7d786 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] allocated time: ${task.time}"

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.postprocessing_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Curate Ecephys
process curation {
	tag 'curation'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:si-0.101.2'

	cpus 4
	memory '32 GB'
	// Allocate 10min per recording hour
	time { max_duration_min.value.toFloat()/60*10 + 'm' }

	input:
	env max_duration_min
	path 'capsule/data/' from postprocessing_to_curation

	output:
	path 'capsule/results/*' into curation_to_visualization
	path 'capsule/results/*' into curation_to_results_collector

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-curation.git" capsule-repo
	git -C capsule-repo checkout e28da8d873c115c3d8c802f20ce27c2ab10bc6f2 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] allocated time: ${task.time}"


	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Unit Classifier Ecephys
process unit_classifier {
	tag 'unit-classifier'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-unit-classifier:si-0.101.2'

	cpus 4
	memory '32 GB'
	// Allocate 30min per recording hour
	time { max_duration_min.value.toFloat()/60*30 + 'm' }

	input:
	env max_duration_min
	path 'capsule/data/' from postprocessing_to_unit_classifier

	output:
	path 'capsule/results/*' into unit_classifier_to_visualization
	path 'capsule/results/*' into unit_classifier_to_results_collector

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-unit-classifier.git" capsule-repo
	git -C capsule-repo checkout 49d2ded8fae71c474aa48c860db086689f1e23ef --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] allocated time: ${task.time}"


	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Visualize Ecephys
process visualization {
	tag 'visualization'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:si-0.101.2'

	cpus 4
	memory '32 GB'
	// Allocate 2h per recording hour
	time { max_duration_min.value.toFloat()/60*2 + 'h' }

	input:
	env max_duration_min
	path 'capsule/data/' from job_dispatch_to_visualization.collect()
	path 'capsule/data/' from unit_classifier_to_visualization.collect()
	path 'capsule/data/' from preprocessing_to_visualization
	path 'capsule/data/' from curation_to_visualization.collect()
	path 'capsule/data/' from spikesort_to_visualization.collect()
	path 'capsule/data/' from postprocessing_to_visualization.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_visualization.collect()

	output:
	path 'capsule/results/*' into visualization_to_results_collector


	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-visualization.git" capsule-repo
	git -C capsule-repo checkout 328c6ac0055a2207c6298556e7ec86d4afc45286 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] allocated time: ${task.time}"


	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Collect Results Ecephys
process results_collector {
	tag 'result-collector'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:si-0.101.2'

	cpus 4
	memory '32 GB'
	// Allocate 1h per recording hour
	time { max_duration_min.value.toFloat()/60 + 'h' }

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	env max_duration_min
	path 'capsule/data/' from job_dispatch_to_results_collector.collect()
	path 'capsule/data/' from preprocessing_to_results_collector.collect()
	path 'capsule/data/' from spikesort_to_results_collector.collect()
	path 'capsule/data/' from postprocessing_to_results_collector.collect()
	path 'capsule/data/' from curation_to_results_collector.collect()
	path 'capsule/data/' from unit_classifier_to_results_collector.collect()
	path 'capsule/data/' from visualization_to_results_collector.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_collect_results.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into results_collector_to_nwb_units

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	echo "KACHERY_ZONE: $KACHERY_ZONE"

	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-results-collector.git" capsule-repo
	git -C capsule-repo checkout 6390a99f625dc2270a11f219c3abbf8408804d9d --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] allocated time: ${task.time}"

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - NWB-Packaging-Subject-Capsule (to rename)
process nwb_subject {
	tag 'nwb-subject'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-nwb:si-0.101.2'

	cpus 4
	memory '32 GB'
	// Allocate 10min per recording hour
	time { max_duration_min.value.toFloat()/60*10 + 'm' }

	input:
	env max_duration_min
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_subject.collect()

	output:
	path 'capsule/results/*' into nwb_subject_to_nwb_ecephys

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/NWB_Packaging_Subject_Capsule.git" capsule-repo
    git -C capsule-repo checkout 0817b7aa432c788d00c49aab0fa5da19a5199d07 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] allocated time: ${task.time}"

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.nwb_subject_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ecephys-nwb
process nwb_ecephys {
	tag 'nwb-ecephys'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-nwb:si-0.101.2'

	cpus 16
	memory '64 GB'
	// Allocate 2h per recording hour
	time { max_duration_min.value.toFloat()/60*2 + 'h' }

	input:
	env max_duration_min
	path 'capsule/data/' from job_dispatch_to_nwb_ecephys.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_ecephys.collect()
	path 'capsule/data/' from nwb_subject_to_nwb_ecephys.collect()

	output:
	path 'capsule/results/*' into nwb_ecephys_to_nwb_units

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ecephys-nwb.git" capsule-repo
	git -C capsule-repo checkout c921c49a0806ccd437a726862d3318a2ef4b9370 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] allocated time: ${task.time}"

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.nwb_ecphys_args}

	echo "[${task.tag}] completed!"
	"""
}


// capsule - aind-units-nwb
process nwb_units {
	tag 'nwb-units'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-nwb:si-0.101.2'

	cpus 4
	memory '32 GB'
	// Allocate 2h per recording hour
	time { max_duration_min.value.toFloat()/60*2 + 'h' }

	publishDir "$RESULTS_PATH/nwb", saveAs: { filename -> new File(filename).getName() }

	input:
	env max_duration_min
	path 'capsule/data/' from job_dispatch_to_nwb_units.collect()
	path 'capsule/data/' from results_collector_to_nwb_units.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_units.collect()
	path 'capsule/data/' from nwb_ecephys_to_nwb_units.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data
	mkdir -p capsule/results
	mkdir -p capsule/scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-units-nwb.git" capsule-repo
	git -C capsule-repo checkout b532ec8dc7d1dc8751bb4de80941772465aaecd9 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] allocated time: ${task.time}"

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
