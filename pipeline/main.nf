#!/usr/bin/env nextflow
// hash:sha256:8ab2ad20e32fe431c1e41b04e39932071a77df8e4e129cc2621cf3f028df2947

nextflow.enable.dsl = 1

params.ecephys_url = 's3://aind-ephys-data/ecephys_713593_2024-02-08_14-10-37'

capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_preprocessing_1_1 = channel.create()
ecephys_to_preprocess_ecephys_2 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_curation_2_3 = channel.create()
ecephys_to_job_dispatch_ecephys_4 = channel.fromPath(params.ecephys_url + "/", type: 'any')
ecephys_to_postprocess_ecephys_5 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_postprocessing_5_6 = channel.create()
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_postprocessing_5_7 = channel.create()
capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_postprocessing_5_8 = channel.create()
capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_visualization_6_9 = channel.create()
capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_visualization_6_10 = channel.create()
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_visualization_6_11 = channel.create()
capsule_aind_ephys_curation_2_to_capsule_aind_ephys_visualization_6_12 = channel.create()
capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_visualization_6_13 = channel.create()
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_visualization_6_14 = channel.create()
ecephys_to_visualize_ecephys_15 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_spikesort_kilosort_25_7_16 = channel.create()
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_unit_classifier_8_17 = channel.create()
capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_results_collector_9_18 = channel.create()
capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_results_collector_9_19 = channel.create()
capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_results_collector_9_20 = channel.create()
capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_results_collector_9_21 = channel.create()
capsule_aind_ephys_curation_2_to_capsule_aind_ephys_results_collector_9_22 = channel.create()
capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_results_collector_9_23 = channel.create()
capsule_aind_ephys_visualization_6_to_capsule_aind_ephys_results_collector_9_24 = channel.create()
ecephys_to_collect_results_ecephys_25 = channel.fromPath(params.ecephys_url + "/", type: 'any')
ecephys_to_nwb_packaging_subject_capsule_26 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_aind_ephys_job_dispatch_4_to_capsule_nwb_packaging_units_11_27 = channel.create()
capsule_nwb_packaging_ecephys_capsule_12_to_capsule_nwb_packaging_units_11_28 = channel.create()
capsule_aind_ephys_results_collector_9_to_capsule_nwb_packaging_units_11_29 = channel.create()
ecephys_to_nwb_packaging_units_30 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_aind_ephys_job_dispatch_4_to_capsule_nwb_packaging_ecephys_capsule_12_31 = channel.create()
ecephys_to_nwb_packaging_ecephys_capsule_32 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_nwb_packaging_subject_capsule_10_to_capsule_nwb_packaging_ecephys_capsule_12_33 = channel.create()

// capsule - Preprocess Ecephys
process capsule_aind_ephys_preprocessing_1 {
	tag 'capsule-0874799'
	container "$REGISTRY_HOST/capsule/05eaf483-9ca3-4a9e-8da8-7d23717f6faf:43b4cc30d75eb70967377f805f93e930"

	cpus 16
	memory '64 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_preprocessing_1_1.flatten()
	path 'capsule/data/ecephys_session' from ecephys_to_preprocess_ecephys_2.collect()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_postprocessing_5_7
	path 'capsule/results/*' into capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_visualization_6_11
	path 'capsule/results/*' into capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_spikesort_kilosort_25_7_16
	path 'capsule/results/*' into capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_results_collector_9_19

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
	git -C capsule-repo checkout 86e1945980fd49fcfc26b42c5c803b51ea655984 --quiet
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
	container "$REGISTRY_HOST/capsule/0e141650-15b9-4150-8277-2337557a8688:c50d821592fa75985b4b032c432f0454"

	cpus 4
	memory '32 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_curation_2_3

	output:
	path 'capsule/results/*' into capsule_aind_ephys_curation_2_to_capsule_aind_ephys_visualization_6_12
	path 'capsule/results/*' into capsule_aind_ephys_curation_2_to_capsule_aind_ephys_results_collector_9_22

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=0e141650-15b9-4150-8277-2337557a8688
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8866682.git" capsule-repo
	git -C capsule-repo checkout e28da8d873c115c3d8c802f20ce27c2ab10bc6f2 --quiet
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
	container "$REGISTRY_HOST/capsule/44358dbf-921b-42d7-897d-9725eebd5ed8:c2d5f2258861d572982b6bfb56ef7d5f"

	cpus 4
	memory '32 GB'

	input:
	path 'capsule/data/ecephys_session' from ecephys_to_job_dispatch_ecephys_4.collect()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_preprocessing_1_1
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_postprocessing_5_8
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_visualization_6_9
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_results_collector_9_18
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_nwb_packaging_units_11_27
	path 'capsule/results/*' into capsule_aind_ephys_job_dispatch_4_to_capsule_nwb_packaging_ecephys_capsule_12_31

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
	git -C capsule-repo checkout 6105ee8a7ebf83a5c63920ac67828609e5b586ba --quiet
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
	container "$REGISTRY_HOST/capsule/6020e947-d8ea-4b64-998b-37404eb5ea51:fb3d4a87fc82a50ee4b4cde886c0a764"

	cpus 16
	memory '128 GB'

	input:
	path 'capsule/data/ecephys_session' from ecephys_to_postprocess_ecephys_5.collect()
	path 'capsule/data/' from capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_postprocessing_5_6.collect()
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_postprocessing_5_7.collect()
	path 'capsule/data/' from capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_postprocessing_5_8.flatten()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_curation_2_3
	path 'capsule/results/*' into capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_visualization_6_14
	path 'capsule/results/*' into capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_unit_classifier_8_17
	path 'capsule/results/*' into capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_results_collector_9_21

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
	git -C capsule-repo checkout dd9b22b82a37753a7e16daad89fe5b2b16c7d786 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_ephys_postprocessing_5_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Visualize Ecephys
process capsule_aind_ephys_visualization_6 {
	tag 'capsule-6668112'
	container "$REGISTRY_HOST/capsule/628c3c19-61bc-4f0c-80b2-00e81f83c176:cd0c00290faa221a0d8e1a44468bc1e6"

	cpus 4
	memory '64 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_visualization_6_9.collect()
	path 'capsule/data/' from capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_visualization_6_10.collect()
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_visualization_6_11
	path 'capsule/data/' from capsule_aind_ephys_curation_2_to_capsule_aind_ephys_visualization_6_12.collect()
	path 'capsule/data/' from capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_visualization_6_13.collect()
	path 'capsule/data/' from capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_visualization_6_14.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_visualize_ecephys_15.collect()

	output:
	path 'capsule/results/*' into capsule_aind_ephys_visualization_6_to_capsule_aind_ephys_results_collector_9_24

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=628c3c19-61bc-4f0c-80b2-00e81f83c176
	export CO_CPUS=4
	export CO_MEMORY=68719476736

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6668112.git" capsule-repo
	git -C capsule-repo checkout f2b19c76edff5afa09d9d1c677b765ebfd11720f --quiet
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
	container "$REGISTRY_HOST/capsule/9c169ec3-5933-4b10-808b-6fa4620e37b7:bc0ece20064b559e6c11214c397a950d"

	cpus 16
	memory '61 GB'
	accelerator 1
	label 'gpu'

	input:
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_spikesort_kilosort_25_7_16

	output:
	path 'capsule/results/*' into capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_postprocessing_5_6
	path 'capsule/results/*' into capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_visualization_6_13
	path 'capsule/results/*' into capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_results_collector_9_20

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
	git -C capsule-repo checkout 1c79356c17a54db6f8925610b82c02220c3a213f --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_ephys_spikesort_kilosort_25_7_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Unit Classifier Ecephys
process capsule_aind_ephys_unit_classifier_8 {
	tag 'capsule-3820244'
	container "$REGISTRY_HOST/capsule/25e96d32-73e9-4a19-b967-f095ffe06c28:0f491d8e09339ffa1eb7cb7d38f3aac4"

	cpus 8
	memory '64 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_unit_classifier_8_17

	output:
	path 'capsule/results/*' into capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_visualization_6_10
	path 'capsule/results/*' into capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_results_collector_9_23

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

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3820244.git" capsule-repo
	git -C capsule-repo checkout 49d2ded8fae71c474aa48c860db086689f1e23ef --quiet
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
	container "$REGISTRY_HOST/capsule/2fcf1c0b-df5d-4822-b078-9e1024a092c5:5022290d1f94aedf19da7b704ffddcc2"

	cpus 8
	memory '64 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ephys_job_dispatch_4_to_capsule_aind_ephys_results_collector_9_18.collect()
	path 'capsule/data/' from capsule_aind_ephys_preprocessing_1_to_capsule_aind_ephys_results_collector_9_19.collect()
	path 'capsule/data/' from capsule_aind_ephys_spikesort_kilosort_25_7_to_capsule_aind_ephys_results_collector_9_20.collect()
	path 'capsule/data/' from capsule_aind_ephys_postprocessing_5_to_capsule_aind_ephys_results_collector_9_21.collect()
	path 'capsule/data/' from capsule_aind_ephys_curation_2_to_capsule_aind_ephys_results_collector_9_22.collect()
	path 'capsule/data/' from capsule_aind_ephys_unit_classifier_8_to_capsule_aind_ephys_results_collector_9_23.collect()
	path 'capsule/data/' from capsule_aind_ephys_visualization_6_to_capsule_aind_ephys_results_collector_9_24.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_collect_results_ecephys_25.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_aind_ephys_results_collector_9_to_capsule_nwb_packaging_units_11_29

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=2fcf1c0b-df5d-4822-b078-9e1024a092c5
	export CO_CPUS=8
	export CO_MEMORY=68719476736

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4820071.git" capsule-repo
	git -C capsule-repo checkout 39482b6ef1c8e03a03983ad09e6fe6e2eb0c75ce --quiet
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
	container "$REGISTRY_HOST/capsule/dde17e00-2bad-4ceb-a00e-699ec25aca64:cfac593fe3228c6ee40d14cd2f3509e0"

	cpus 4
	memory '32 GB'

	input:
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_packaging_subject_capsule_26.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_subject_capsule_10_to_capsule_nwb_packaging_ecephys_capsule_12_33

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
	git -C capsule-repo checkout 0817b7aa432c788d00c49aab0fa5da19a5199d07 --quiet
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
	container "$REGISTRY_HOST/capsule/9be90966-938b-4084-8959-4966e9dbb955:78e629e421f790bb02e9c2677565e458"

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH/nwb", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_ephys_job_dispatch_4_to_capsule_nwb_packaging_units_11_27.collect()
	path 'capsule/data/' from capsule_nwb_packaging_ecephys_capsule_12_to_capsule_nwb_packaging_units_11_28.collect()
	path 'capsule/data/' from capsule_aind_ephys_results_collector_9_to_capsule_nwb_packaging_units_11_29.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_packaging_units_30.collect()

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
	git -C capsule-repo checkout 727062b86edbfd11b5e87f8eb99f58a072637f72 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - NWB-Packaging-Ecephys-Capsule
process capsule_nwb_packaging_ecephys_capsule_12 {
	tag 'capsule-5741357'
	container "$REGISTRY_HOST/capsule/2cfc8f08-1042-4e84-ba44-f33e2a8021a8:54da71ffb4a1b6bc5d3f654fd675a50b"

	cpus 8
	memory '64 GB'

	input:
	path 'capsule/data/' from capsule_aind_ephys_job_dispatch_4_to_capsule_nwb_packaging_ecephys_capsule_12_31.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_packaging_ecephys_capsule_32.collect()
	path 'capsule/data/' from capsule_nwb_packaging_subject_capsule_10_to_capsule_nwb_packaging_ecephys_capsule_12_33.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_ecephys_capsule_12_to_capsule_nwb_packaging_units_11_28

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=2cfc8f08-1042-4e84-ba44-f33e2a8021a8
	export CO_CPUS=8
	export CO_MEMORY=68719476736

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5741357.git" capsule-repo
	git -C capsule-repo checkout c921c49a0806ccd437a726862d3318a2ef4b9370 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_nwb_packaging_ecephys_capsule_12_args}

	echo "[${task.tag}] completed!"
	"""
}
