#!/usr/bin/env nextflow
nextflow.enable.dsl = 1

params.ecephys_path = DATA_PATH + "/ecephys"

println "DATA_PATH: ${DATA_PATH}"
println "RESULTS_PATH: ${RESULTS_PATH}"
println "Params: ${params}"

job_dispatch_to_preprocessing_1 = channel.create()
ecephys_to_preprocessing_ecephys_si__2 = channel.fromPath(params.ecephys_path + "/", type: 'any')
postprocessing_to_curation_3 = channel.create()
ecephys_to_job_dispatch_ecephys_si__4 = channel.fromPath(params.ecephys_path + "/", type: 'any')
spikesort_kilosort25_to_postprocessing_5 = channel.create()
preprocessing_to_postprocessing_6 = channel.create()
job_dispatch_to_postprocessing_7 = channel.create()
unit_classifier_to_visualization_8 = channel.create()
preprocessing_to_visualization_9 = channel.create()
curation_to_visualization_10 = channel.create()
spikesort_kilosort25_to_visualization_11 = channel.create()
postprocessing_to_visualization_12 = channel.create()
ecephys_to_visualize_ecephys_13 = channel.fromPath(params.ecephys_path + "/", type: 'any')
preprocessing_to_spikesort_kilosort25_14 = channel.create()
postprocessing_to_unit_classifier_15 = channel.create()
preprocessing_to_results_collector_16 = channel.create()
spikesort_kilosort25_to_results_collector_17 = channel.create()
postprocessing_to_results_collector_18 = channel.create()
curation_to_results_collector_19 = channel.create()
unit_classifier_to_results_collector_20 = channel.create()
visualization_to_results_collector_21 = channel.create()
ecephys_to_collect_results_ecephys_22 = channel.fromPath(params.ecephys_path + "/", type: 'any')
ecephys_to_nwb_packaging_subject_capsule_si__23 = channel.fromPath(params.ecephys_path + "/", type: 'any')
job_dispatch_to_nwb_units_24 = channel.create()
results_collector_to_nwb_units_25 = channel.create()
ecephys_to_nwb_packaging_units_si__26 = channel.fromPath(params.ecephys_path + "/", type: 'any')
nwb_subject_to_nwb_units_27 = channel.create()


// capsule - Job Dispatch Ecephys
process job_dispatch {
	tag 'capsule-5832718'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:latest'

	input:
	path 'capsule/data/ecephys_session' from ecephys_to_job_dispatch_ecephys_si__4.collect()

	output:
	path 'capsule/results/*' into job_dispatch_to_preprocessing_1
	path 'capsule/results/*' into job_dispatch_to_postprocessing_7
	path 'capsule/results/*' into job_dispatch_to_nwb_units_24

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-job-dispatch.git" capsule-repo
	git -C capsule-repo checkout 2b5ff34ee7c6892f51a4931113b40b5752c25fb7 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.job_dispatch_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Preprocess Ecephys
process preprocessing {
	tag 'capsule-4923505'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:latest'

	input:
	path 'capsule/data/' from job_dispatch_to_preprocessing_1.flatten()
	path 'capsule/data/ecephys_session' from ecephys_to_preprocessing_ecephys_si__2.collect()

	output:
	path 'capsule/results/*' into preprocessing_to_postprocessing_6
	path 'capsule/results/*' into preprocessing_to_visualization_9
	path 'capsule/results/*' into preprocessing_to_spikesort_kilosort25_14
	path 'capsule/results/*' into preprocessing_to_results_collector_16

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-preprocessing.git" capsule-repo
	git -C capsule-repo checkout d24ba855e55c9202e8ce9a17c581cc07d9a08cc3 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.preprocessing_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Spikesort Kilosort2.5 Ecephys
process spikesort_kilosort25 {
	tag 'capsule-2633671'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-spikesort-kilosort25:latest'
	containerOptions '--gpus all'

	input:
	path 'capsule/data/' from preprocessing_to_spikesort_kilosort25_14

	output:
	path 'capsule/results/*' into spikesort_kilosort25_to_postprocessing_5
	path 'capsule/results/*' into spikesort_kilosort25_to_visualization_11
	path 'capsule/results/*' into spikesort_kilosort25_to_results_collector_17

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-spikesort-kilosort25.git" capsule-repo
	git -C capsule-repo checkout b8fd5dcfdb3b1c584335075a1679051e23066b67 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}


// capsule - Postprocess Ecephys
process postprocessing {
	tag 'capsule-5473620'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:latest'

	input:
	path 'capsule/data/' from spikesort_kilosort25_to_postprocessing_5.collect()
	path 'capsule/data/' from preprocessing_to_postprocessing_6.collect()
	path 'capsule/data/' from job_dispatch_to_postprocessing_7.flatten()

	output:
	path 'capsule/results/*' into postprocessing_to_curation_3
	path 'capsule/results/*' into postprocessing_to_visualization_12
	path 'capsule/results/*' into postprocessing_to_unit_classifier_15
	path 'capsule/results/*' into postprocessing_to_results_collector_18

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-postprocessing.git" capsule-repo
	git -C capsule-repo checkout e1be32db7835b0254a7dd9c1dbbbdb619531280b --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Curate Ecephys
process curation {
	tag 'capsule-8866682'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:latest'

	input:
	path 'capsule/data/' from postprocessing_to_curation_3

	output:
	path 'capsule/results/*' into curation_to_visualization_10
	path 'capsule/results/*' into curation_to_results_collector_19

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-curation.git" capsule-repo
	git -C capsule-repo checkout 3453bfe103f0ec686b1499ce9d578ce1c34cc437 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Unit Classifier Ecephys
process unit_classifier {
	tag 'capsule-3820244'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-unit-classifier:latest'

	input:
	path 'capsule/data/' from postprocessing_to_unit_classifier_15

	output:
	path 'capsule/results/*' into unit_classifier_to_visualization_8
	path 'capsule/results/*' into unit_classifier_to_results_collector_20

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	ln -s "/tmp/data/unit_classifier_models_v1.0" "capsule/data/unit_classifier_models_v1.0" # id: 7daf6149-88d2-44ba-8218-b519b4fba45f

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-unit-classifier.git" capsule-repo
	git -C capsule-repo checkout 3b910faff714de4cbe8ac3b6e7bd2dd169661dcf --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Visualize Ecephys
process visualization {
	tag 'capsule-6668112'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:latest'
	containerOptions '--env KACHERY_ZONE --env KACHERY_CLOUD_CLIENT_ID --env KACHERY_CLOUD_PRIVATE_KEY'

	input:
	path 'capsule/data/' from unit_classifier_to_visualization_8.collect()
	path 'capsule/data/' from preprocessing_to_visualization_9
	path 'capsule/data/' from curation_to_visualization_10.collect()
	path 'capsule/data/' from spikesort_kilosort25_to_visualization_11.collect()
	path 'capsule/data/' from postprocessing_to_visualization_12.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_visualize_ecephys_13.collect()

	output:
	path 'capsule/results/*' into visualization_to_results_collector_21

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-visualization.git" capsule-repo
	git -C capsule-repo checkout 870784619b9dd8360956f169f693b24f61ca4364 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Collect Results Ecephys
process results_collector {
	tag 'capsule-4820071'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-base:latest'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from preprocessing_to_results_collector_16.collect()
	path 'capsule/data/' from spikesort_kilosort25_to_results_collector_17.collect()
	path 'capsule/data/' from postprocessing_to_results_collector_18.collect()
	path 'capsule/data/' from curation_to_results_collector_19.collect()
	path 'capsule/data/' from unit_classifier_to_results_collector_20.collect()
	path 'capsule/data/' from visualization_to_results_collector_21.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_collect_results_ecephys_22.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into results_collector_to_nwb_units_25

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/aind-ephys-results-collector.git" capsule-repo
	git -C capsule-repo checkout 78c4aeb034b63035cd2fc4724f88d577524f70e5 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - NWB-Packaging-Subject-Capsule
process nwb_subject {
	tag 'capsule-9109637'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-nwb:latest'

	input:
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_packaging_subject_capsule_si__23.collect()

	output:
	path 'capsule/results/*' into nwb_subject_to_nwb_units_27

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/NWB_Packaging_Subject_Capsule.git" capsule-repo
    git -C capsule-repo checkout 6498a1bae14bf7edeb1a282accd39a41156a0952 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.nwb_subject_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - NWB-Packaging-Units
process nwb_units {
	tag 'capsule-6946197'
	container 'ghcr.io/allenneuraldynamics/aind-ephys-pipeline-nwb:latest'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from job_dispatch_to_nwb_units_24.collect()
	path 'capsule/data/' from results_collector_to_nwb_units_25.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_packaging_units_si__26.collect()
	path 'capsule/data/' from nwb_subject_to_nwb_units_27.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://github.com/AllenNeuralDynamics/NWB_Packaging_Units.git" capsule-repo
	git -C capsule-repo checkout 3d201ac586e76175f24ac372a767581b29922538 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
