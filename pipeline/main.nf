#!/usr/bin/env nextflow
// hash:sha256:31a5f99b74f9d9b0677df4ad027f4645c80f8c36dc1a366ef82d838d3e0aae2f

nextflow.enable.dsl = 1

params.ecephys_url = 's3://aind-ephys-data/ecephys_713593_2024-02-08_14-10-37'

capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_preprocessing_1_1 = channel.create()
ecephys_to_aind_ephys_preprocessing_2 = channel.fromPath(params.ecephys_url + "/*", type: 'any')
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_curation_2_3 = channel.create()
ecephys_to_aind_ephys_job_dispatch_4 = channel.fromPath(params.ecephys_url + "/*", type: 'any')
capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_postprocessing_5_5 = channel.create()
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_postprocessing_5_6 = channel.create()
capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_postprocessing_5_7 = channel.create()
capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_visualization_6_8 = channel.create()
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_visualization_6_9 = channel.create()
capsule_aind_ephys_curation_2_to_capsule_aind_ephys_visualization_6_10 = channel.create()
capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_visualization_6_11 = channel.create()
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_visualization_6_12 = channel.create()
ecephys_to_aind_ephys_visualization_13 = channel.fromPath(params.ecephys_url + "/*", type: 'any')
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_spikesort_kilosort_25_7_14 = channel.create()
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_unit_classifier_8_15 = channel.create()
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_results_collector_9_16 = channel.create()
capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_results_collector_9_17 = channel.create()
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_results_collector_9_18 = channel.create()
capsule_aind_ephys_curation_2_to_capsule_aind_ephys_results_collector_9_19 = channel.create()
capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_results_collector_9_20 = channel.create()
capsule_aind_ephys_visualization_6_to_capsule_aind_ephys_results_collector_9_21 = channel.create()
ecephys_to_aind_ephys_results_collector_22 = channel.fromPath(params.ecephys_url + "/*", type: 'any')
ecephys_to_nwb_packaging_subject_capsule_23 = channel.fromPath(params.ecephys_url + "/*", type: 'any')
capsule_aind_ephys_results_collector_9_to_capsule_nwb_packaging_units_11_24 = channel.create()
ecephys_to_nwb_packaging_units_25 = channel.fromPath(params.ecephys_url + "/*", type: 'any')
capsule_nwb_packaging_subject_capsule_10_to_capsule_nwb_packaging_units_11_26 = channel.create()

// capsule - aind-ephys-preprocessing
process capsule_aind_ephys_preprocessing_1 {
	tag 'capsule-0874799'
	container 'registry.codeocean.allenneuraldynamics.org/capsule/05eaf483-9ca3-4a9e-8da8-7d23717f6faf'

	cpus 16
	memory '64 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_preprocessing_1_1.flatten()
	path 'capsule/data/ecephys_session/' from ecephys_to_aind_ephys_preprocessing_2.collect()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_postprocessing_5_6
	path 'capsule/results/*' into capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_visualization_6_9
	path 'capsule/results/*' into capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_spikesort_kilosort_25_7_14
	path 'capsule/results/*' into capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_results_collector_9_16

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=05eaf483-9ca3-4a9e-8da8-7d23717f6faf
	export CO_CPUS=16
	export CO_MEMORY=68719476736

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-0874799.git" capsule-repo
	git -C capsule-repo checkout 993eafe057c4c2f301625eadaa160e4b1992e2b1 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_ephys_preprocessing_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ephys-curation
process capsule_aind_ephys_curation_2 {
	tag 'capsule-8866682'
	container 'registry.codeocean.allenneuraldynamics.org/capsule/0e141650-15b9-4150-8277-2337557a8688'

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_curation_2_3

	output:
	path 'capsule/results/*' into capsule_aind_ephys_curation_2_to_capsule_aind_ephys_visualization_6_10
	path 'capsule/results/*' into capsule_aind_ephys_curation_2_to_capsule_aind_ephys_results_collector_9_19

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=0e141650-15b9-4150-8277-2337557a8688
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-8866682.git" capsule-repo
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

// capsule - aind-ephys-job-dispatch
process capsule_aind_ephys_job_dispatch_4 {
	tag 'capsule-5089190'
	container 'registry.codeocean.allenneuraldynamics.org/capsule/44358dbf-921b-42d7-897d-9725eebd5ed8'

	cpus 4
	memory '32 GB'

	input:
	path 'capsule/data/ecephys_session/' from ecephys_to_aind_ephys_job_dispatch_4.collect()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_preprocessing_1_1
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_postprocessing_5_7

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=44358dbf-921b-42d7-897d-9725eebd5ed8
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-5089190.git" capsule-repo
	git -C capsule-repo checkout 19a83b5df052641903273f48e5368358ecadf9b2 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_ephys_job_dispatch_4_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ephys-postprocessing
process capsule_aind_ephys_postprocessing_5 {
	tag 'capsule-5473620'
	container 'registry.codeocean.allenneuraldynamics.org/capsule/6020e947-d8ea-4b64-998b-37404eb5ea51'

	cpus 16
	memory '128 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_postprocessing_5_5.collect()
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_postprocessing_5_6.collect()
	path 'capsule/data/' from capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_postprocessing_5_7.flatten()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_curation_2_3
	path 'capsule/results/*' into capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_visualization_6_12
	path 'capsule/results/*' into capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_unit_classifier_8_15
	path 'capsule/results/*' into capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_results_collector_9_18

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=6020e947-d8ea-4b64-998b-37404eb5ea51
	export CO_CPUS=16
	export CO_MEMORY=137438953472

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-5473620.git" capsule-repo
	git -C capsule-repo checkout b2ec4f051a5860a04ed693a79f35f5aca917e97f --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ephys-visualization
process capsule_aind_ephys_visualization_6 {
	tag 'capsule-6668112'
	container 'registry.codeocean.allenneuraldynamics.org/capsule/628c3c19-61bc-4f0c-80b2-00e81f83c176'

	cpus 4
	memory '32 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_visualization_6_8.collect()
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_visualization_6_9
	path 'capsule/data/' from capsule_aind_ephys_curation_2_to_capsule_aind_ephys_visualization_6_10.collect()
	path 'capsule/data/' from capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_visualization_6_11.collect()
	path 'capsule/data/' from capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_visualization_6_12.collect()
	path 'capsule/data/ecephys_session/' from ecephys_to_aind_ephys_visualization_13.collect()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_visualization_6_to_capsule_aind_ephys_results_collector_9_21

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=628c3c19-61bc-4f0c-80b2-00e81f83c176
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-6668112.git" capsule-repo
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

// capsule - aind-ephys-spikesort-kilosort25
process capsule_aind_ephys_spikesort_kilosort_25_7 {
	tag 'capsule-2633671'
	container 'registry.codeocean.allenneuraldynamics.org/capsule/9c169ec3-5933-4b10-808b-6fa4620e37b7'

	cpus 16
	memory '61 GB'
	accelerator 1
	label 'gpu'

	input:
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_spikesort_kilosort_25_7_14

	output:
	path 'capsule/results/*' into capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_postprocessing_5_5
	path 'capsule/results/*' into capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_visualization_6_11
	path 'capsule/results/*' into capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_results_collector_9_17

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=9c169ec3-5933-4b10-808b-6fa4620e37b7
	export CO_CPUS=16
	export CO_MEMORY=65498251264

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-2633671.git" capsule-repo
	git -C capsule-repo checkout f16003e1518abedc55fe78ef99a4b8e65d1c56c6 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-ephys-unit-classifier
process capsule_aind_ephys_unit_classifier_8 {
	tag 'capsule-3820244'
	container 'registry.codeocean.allenneuraldynamics.org/capsule/25e96d32-73e9-4a19-b967-f095ffe06c28'

	cpus 8
	memory '64 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_unit_classifier_8_15

	output:
	path 'capsule/results/*' into capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_visualization_6_8
	path 'capsule/results/*' into capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_results_collector_9_20

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=25e96d32-73e9-4a19-b967-f095ffe06c28
	export CO_CPUS=8
	export CO_MEMORY=68719476736

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	ln -s "/tmp/data/unit_classifier_models_v1.0" "capsule/data/unit_classifier_models_v1.0" # id: 7daf6149-88d2-44ba-8218-b519b4fba45f
	
	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-3820244.git" capsule-repo
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

// capsule - aind-ephys-results-collector
process capsule_aind_ephys_results_collector_9 {
	tag 'capsule-4820071'
	container 'registry.codeocean.allenneuraldynamics.org/capsule/2fcf1c0b-df5d-4822-b078-9e1024a092c5'

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_results_collector_9_16.collect()
	path 'capsule/data/' from capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_results_collector_9_17.collect()
	path 'capsule/data/' from capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_results_collector_9_18.collect()
	path 'capsule/data/' from capsule_aind_ephys_curation_2_to_capsule_aind_ephys_results_collector_9_19.collect()
	path 'capsule/data/' from capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_results_collector_9_20.collect()
	path 'capsule/data/' from capsule_aind_ephys_visualization_6_to_capsule_aind_ephys_results_collector_9_21.collect()
	path 'capsule/data/ecephys_session/' from ecephys_to_aind_ephys_results_collector_22.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ephys_results_collector_9_to_capsule_nwb_packaging_units_11_24

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=2fcf1c0b-df5d-4822-b078-9e1024a092c5
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-4820071.git" capsule-repo
	git -C capsule-repo checkout ef0b4bc266bb835399b39026538a5fc7d07e5757 --quiet
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
process capsule_nwb_packaging_subject_capsule_10 {
	tag 'capsule-1748641'
	container 'registry.codeocean.allenneuraldynamics.org/capsule/dde17e00-2bad-4ceb-a00e-699ec25aca64'

	cpus 4
	memory '32 GB'

	input:
	path 'capsule/data/ecephys_session/' from ecephys_to_nwb_packaging_subject_capsule_23.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_subject_capsule_10_to_capsule_nwb_packaging_units_11_26

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=dde17e00-2bad-4ceb-a00e-699ec25aca64
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-1748641.git" capsule-repo
	git -C capsule-repo checkout 9dc8a496f86fe38250d584b8e3d396581b7e404b --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_nwb_packaging_subject_capsule_10_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - NWB-Packaging-Units
process capsule_nwb_packaging_units_11 {
	tag 'capsule-7106853'
	container 'registry.codeocean.allenneuraldynamics.org/capsule/9be90966-938b-4084-8959-4966e9dbb955'

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ephys_results_collector_9_to_capsule_nwb_packaging_units_11_24.collect()
	path 'capsule/data/ecephys_session/' from ecephys_to_nwb_packaging_units_25.collect()
	path 'capsule/data/' from capsule_nwb_packaging_subject_capsule_10_to_capsule_nwb_packaging_units_11_26.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=9be90966-938b-4084-8959-4966e9dbb955
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-7106853.git" capsule-repo
	git -C capsule-repo checkout e4b0eca9bb5b2e76ffd7815b70dab5df55955e82 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
