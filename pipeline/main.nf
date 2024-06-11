#!/usr/bin/env nextflow
// hash:sha256:1c8bd5e1952a2ab9b8a83d8783a963e16b62d30a0b5ee8f642f724aa2be581a4

nextflow.enable.dsl = 1

params.ecephys_url = 's3://aind-ephys-data/ecephys_713593_2024-02-08_14-10-37'

capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_preprocessing_1_1 = channel.create()
ecephys_to_preprocess_ecephys_2 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_curation_2_3 = channel.create()
ecephys_to_job_dispatch_ecephys_4 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_postprocessing_5_5 = channel.create()
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_postprocessing_5_6 = channel.create()
capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_postprocessing_5_7 = channel.create()
capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_visualization_6_8 = channel.create()
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_visualization_6_9 = channel.create()
capsule_aind_ephys_curation_2_to_capsule_aind_ephys_visualization_6_10 = channel.create()
capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_visualization_6_11 = channel.create()
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_visualization_6_12 = channel.create()
ecephys_to_visualize_ecephys_13 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_spikesort_kilosort_25_7_14 = channel.create()
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_unit_classifier_8_15 = channel.create()
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_results_collector_9_16 = channel.create()
capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_results_collector_9_17 = channel.create()
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_results_collector_9_18 = channel.create()
capsule_aind_ephys_curation_2_to_capsule_aind_ephys_results_collector_9_19 = channel.create()
capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_results_collector_9_20 = channel.create()
capsule_aind_ephys_visualization_6_to_capsule_aind_ephys_results_collector_9_21 = channel.create()
ecephys_to_collect_results_ecephys_22 = channel.fromPath(params.ecephys_url + "/", type: 'any')
ecephys_to_nwb_packaging_subject_capsule_23 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_aind_ephys_job_dispatch_4_to_capsule_nwb_packaging_units_11_24 = channel.create()
capsule_aind_ephys_results_collector_9_to_capsule_nwb_packaging_units_11_25 = channel.create()
ecephys_to_nwb_packaging_units_26 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_nwb_packaging_subject_capsule_10_to_capsule_nwb_packaging_units_11_27 = channel.create()

// capsule - Preprocess Ecephys
process capsule_aind_ephys_preprocessing_1 {
	tag 'capsule-0874799'
	container "$REGISTRY_HOST/capsule/05eaf483-9ca3-4a9e-8da8-7d23717f6faf:9e533d0c01908fdc31ff359d64a82588"

	cpus 16
	memory '64 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_preprocessing_1_1.flatten()
	path 'capsule/data/ecephys_session' from ecephys_to_preprocess_ecephys_2.collect()

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
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0874799.git" capsule-repo
	git -C capsule-repo checkout d24ba855e55c9202e8ce9a17c581cc07d9a08cc3 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_ephys_preprocessing_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Curate Ecephys
process capsule_aind_ephys_curation_2 {
	tag 'capsule-8866682'
	container "$REGISTRY_HOST/capsule/0e141650-15b9-4150-8277-2337557a8688:4cae5f32822c2ea1670166440aec4733"

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
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8866682.git" capsule-repo
	git -C capsule-repo checkout bb6bb3528f590242cb6b707e07daac7d525216d2 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Job Dispatch Ecephys
process capsule_aind_ephys_job_dispatch_4 {
	tag 'capsule-5089190'
	container "$REGISTRY_HOST/capsule/44358dbf-921b-42d7-897d-9725eebd5ed8:591dac60fa05b414c00d87631fd5dab1"

	cpus 4
	memory '32 GB'

	input:
	path 'capsule/data/ecephys_session' from ecephys_to_job_dispatch_ecephys_4.collect()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_preprocessing_1_1
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_postprocessing_5_7
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_nwb_packaging_units_11_24

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
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5089190.git" capsule-repo
	git -C capsule-repo checkout 31beaed981c0287c77b7def3d2b598ee048852c5 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_ephys_job_dispatch_4_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Postprocess Ecephys
process capsule_aind_ephys_postprocessing_5 {
	tag 'capsule-5473620'
	container "$REGISTRY_HOST/capsule/6020e947-d8ea-4b64-998b-37404eb5ea51:4cae5f32822c2ea1670166440aec4733"

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
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5473620.git" capsule-repo
	git -C capsule-repo checkout e8cafd29f4673cd685c70dd3b63506e8fd39ba35 --quiet
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
process capsule_aind_ephys_visualization_6 {
	tag 'capsule-6668112'
	container "$REGISTRY_HOST/capsule/628c3c19-61bc-4f0c-80b2-00e81f83c176:8f86b949372558a484e700b70bac19b8"

	cpus 4
	memory '32 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_visualization_6_8.collect()
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_visualization_6_9
	path 'capsule/data/' from capsule_aind_ephys_curation_2_to_capsule_aind_ephys_visualization_6_10.collect()
	path 'capsule/data/' from capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_visualization_6_11.collect()
	path 'capsule/data/' from capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_visualization_6_12.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_visualize_ecephys_13.collect()

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
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6668112.git" capsule-repo
	git -C capsule-repo checkout 410ce8154787de96e1028cc6051376c04f31d094 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Spikesort Kilosort2.5 Ecephys
process capsule_aind_ephys_spikesort_kilosort_25_7 {
	tag 'capsule-2633671'
	container "$REGISTRY_HOST/capsule/9c169ec3-5933-4b10-808b-6fa4620e37b7:bc96d10f06f632c293eef75ab11f0597"

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
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-2633671.git" capsule-repo
	git -C capsule-repo checkout b40bc7d893c06fbce236aec5f98f5b964536adbc --quiet
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
process capsule_aind_ephys_unit_classifier_8 {
	tag 'capsule-3820244'
	container "$REGISTRY_HOST/capsule/25e96d32-73e9-4a19-b967-f095ffe06c28:a81d4ce09ce7d226f565d9c950315f02"

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
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3820244.git" capsule-repo
	git -C capsule-repo checkout 2f22f1b02a8ec1c31f415375f726d7f39f5d65cb --quiet
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
process capsule_aind_ephys_results_collector_9 {
	tag 'capsule-4820071'
	container "$REGISTRY_HOST/capsule/2fcf1c0b-df5d-4822-b078-9e1024a092c5:57dc7eca8e9ba2f0608eb121609a18b8"

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
	path 'capsule/data/ecephys_session' from ecephys_to_collect_results_ecephys_22.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ephys_results_collector_9_to_capsule_nwb_packaging_units_11_25

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
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4820071.git" capsule-repo
	git -C capsule-repo checkout a5013dc4869a4d96ee83d6441ea4b1604439eade --quiet
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
	container "$REGISTRY_HOST/capsule/dde17e00-2bad-4ceb-a00e-699ec25aca64:4b85e470d25ef637f46fc5ee05dcd7b5"

	cpus 4
	memory '32 GB'

	input:
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_packaging_subject_capsule_23.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_subject_capsule_10_to_capsule_nwb_packaging_units_11_27

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
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1748641.git" capsule-repo
	git -C capsule-repo checkout fc9a617bb50731fa1ef4f8f6179b5a25331d4076 --quiet
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
	container "$REGISTRY_HOST/capsule/9be90966-938b-4084-8959-4966e9dbb955:92fed35888d16cf6c740daa4a5be21b9"

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ephys_job_dispatch_4_to_capsule_nwb_packaging_units_11_24.collect()
	path 'capsule/data/' from capsule_aind_ephys_results_collector_9_to_capsule_nwb_packaging_units_11_25.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_packaging_units_26.collect()
	path 'capsule/data/' from capsule_nwb_packaging_subject_capsule_10_to_capsule_nwb_packaging_units_11_27.collect()

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
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7106853.git" capsule-repo
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