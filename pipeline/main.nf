#!/usr/bin/env nextflow
// hash:sha256:349be35417e7c55dff5c324080a96eba720846d199d5c75437acae74f64ffdaa

nextflow.enable.dsl = 1

params.ecephys_url = 's3://aind-ephys-data/ecephys_684810_2023-10-13_15-11-47'

capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_preprocessing_1_1 = channel.create()
ecephys_to_aind_ephys_preprocessing_2 = channel.fromPath(params.ecephys_url + "/*", type: 'any')
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_curation_2_3 = channel.create()
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_results_collector_3_4 = channel.create()
capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_results_collector_3_5 = channel.create()
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_results_collector_3_6 = channel.create()
capsule_aind_ephys_curation_2_to_capsule_aind_ephys_results_collector_3_7 = channel.create()
capsule_aind_ephys_visualization_6_to_capsule_aind_ephys_results_collector_3_8 = channel.create()
ecephys_to_aind_ephys_results_collector_9 = channel.fromPath(params.ecephys_url + "/*", type: 'any')
ecephys_to_aind_ephys_job_dispatch_10 = channel.fromPath(params.ecephys_url + "/*", type: 'any')
capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_postprocessing_5_11 = channel.create()
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_postprocessing_5_12 = channel.create()
capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_postprocessing_5_13 = channel.create()
capsule_aind_ephys_curation_2_to_capsule_aind_ephys_visualization_6_14 = channel.create()
capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_visualization_6_15 = channel.create()
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_visualization_6_16 = channel.create()
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_visualization_6_17 = channel.create()
ecephys_to_aind_ephys_visualization_18 = channel.fromPath(params.ecephys_url + "/*", type: 'any')
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_spikesort_kilosort_25_7_19 = channel.create()

// capsule - aind-ephys-preprocessing
process capsule_aind_ephys_preprocessing_1 {
	tag 'capsule-0874799'
	container 'registry.codeocean.allenneuraldynamics.org/capsule/05eaf483-9ca3-4a9e-8da8-7d23717f6faf'

	cpus 32
	memory '128 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_preprocessing_1_1.flatten()
	path 'capsule/data/ecephys_session/' from ecephys_to_aind_ephys_preprocessing_2.collect()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_results_collector_3_4
	path 'capsule/results/*' into capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_postprocessing_5_12
	path 'capsule/results/*' into capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_visualization_6_17
	path 'capsule/results/*' into capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_spikesort_kilosort_25_7_19

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=05eaf483-9ca3-4a9e-8da8-7d23717f6faf
	export CO_CPUS=32
	export CO_MEMORY=137438953472

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-0874799.git" capsule-repo
	git -C capsule-repo checkout 57dc39a95e15553b88bb88050aabb852d4f195f1 --quiet
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
	path 'capsule/results/*' into capsule_aind_ephys_curation_2_to_capsule_aind_ephys_results_collector_3_7
	path 'capsule/results/*' into capsule_aind_ephys_curation_2_to_capsule_aind_ephys_visualization_6_14

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
	git -C capsule-repo checkout 5884f7e821e28777dcbd0fa7008ed18e34923221 --quiet
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
process capsule_aind_ephys_results_collector_3 {
	tag 'capsule-4820071'
	container 'registry.codeocean.allenneuraldynamics.org/capsule/2fcf1c0b-df5d-4822-b078-9e1024a092c5'

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_results_collector_3_4.collect()
	path 'capsule/data/' from capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_results_collector_3_5.collect()
	path 'capsule/data/' from capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_results_collector_3_6.collect()
	path 'capsule/data/' from capsule_aind_ephys_curation_2_to_capsule_aind_ephys_results_collector_3_7.collect()
	path 'capsule/data/' from capsule_aind_ephys_visualization_6_to_capsule_aind_ephys_results_collector_3_8.collect()
	path 'capsule/data/ecephys_session/' from ecephys_to_aind_ephys_results_collector_9.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=2fcf1c0b-df5d-4822-b078-9e1024a092c5
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-4820071.git" capsule-repo
	git -C capsule-repo checkout bd6fda6747feef4d21baed70b304bc5d327099dd --quiet
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

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/ecephys_session/' from ecephys_to_aind_ephys_job_dispatch_10.collect()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_preprocessing_1_1
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_postprocessing_5_13

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=44358dbf-921b-42d7-897d-9725eebd5ed8
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-5089190.git" capsule-repo
	git -C capsule-repo checkout 93e070786fb757acfceb1aab4d4e24391654f491 --quiet
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

	cpus 32
	memory '128 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_postprocessing_5_11.collect()
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_postprocessing_5_12.collect()
	path 'capsule/data/' from capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_postprocessing_5_13.flatten()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_curation_2_3
	path 'capsule/results/*' into capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_results_collector_3_6
	path 'capsule/results/*' into capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_visualization_6_16

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=6020e947-d8ea-4b64-998b-37404eb5ea51
	export CO_CPUS=32
	export CO_MEMORY=137438953472

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-5473620.git" capsule-repo
	git -C capsule-repo checkout a5f932b6ca412033b2d516e5eda815e49150b5c5 --quiet
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

	cpus 2
	memory '16 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_curation_2_to_capsule_aind_ephys_visualization_6_14
	path 'capsule/data/' from capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_visualization_6_15.collect()
	path 'capsule/data/' from capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_visualization_6_16.collect()
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_visualization_6_17.collect()
	path 'capsule/data/ecephys_session/' from ecephys_to_aind_ephys_visualization_18.collect()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_visualization_6_to_capsule_aind_ephys_results_collector_3_8

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=628c3c19-61bc-4f0c-80b2-00e81f83c176
	export CO_CPUS=2
	export CO_MEMORY=17179869184

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@codeocean.allenneuraldynamics.org/capsule-6668112.git" capsule-repo
	git -C capsule-repo checkout 80dad23a4ed1be7234b816976b83026e11926d1d --quiet
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
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_spikesort_kilosort_25_7_19

	output:
	path 'capsule/results/*' into capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_results_collector_3_5
	path 'capsule/results/*' into capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_postprocessing_5_11
	path 'capsule/results/*' into capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_visualization_6_15

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
	git -C capsule-repo checkout 4203e25d6b3905ec66ca8e1005059abcdc1e079b --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
