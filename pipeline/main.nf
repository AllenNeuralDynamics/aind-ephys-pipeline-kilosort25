#!/usr/bin/env nextflow
// hash:sha256:7639345344b2270beabef1fc4c1e31945bd9a50de8425b03a3378e0ab4b3e83a

nextflow.enable.dsl = 1

params.ecephys_url = 's3://aind-ephys-data/ecephys_713593_2024-02-08_14-10-37'

capsule_job_dispatch_ecephys_4_to_capsule_preprocess_ecephys_si_1_1 = channel.create()
ecephys_to_preprocess_ecephys_2 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_postprocess_ecephysanalyzer_5_to_capsule_curate_ecephysanalyzer_2_3 = channel.create()
ecephys_to_job_dispatch_ecephys_4 = channel.fromPath(params.ecephys_url + "/", type: 'any')
ecephys_to_postprocess_ecephys_5 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_spikesort_kilosort_25_ecephysanalyzer_7_to_capsule_postprocess_ecephysanalyzer_5_6 = channel.create()
capsule_preprocess_ecephys_si_1_to_capsule_postprocess_ecephysanalyzer_5_7 = channel.create()
capsule_job_dispatch_ecephys_4_to_capsule_postprocess_ecephysanalyzer_5_8 = channel.create()
capsule_unit_classifier_ecephysanalyzer_8_to_capsule_visualize_ecephysanalyzer_6_9 = channel.create()
capsule_preprocess_ecephys_si_1_to_capsule_visualize_ecephysanalyzer_6_10 = channel.create()
capsule_curate_ecephysanalyzer_2_to_capsule_visualize_ecephysanalyzer_6_11 = channel.create()
capsule_spikesort_kilosort_25_ecephysanalyzer_7_to_capsule_visualize_ecephysanalyzer_6_12 = channel.create()
capsule_postprocess_ecephysanalyzer_5_to_capsule_visualize_ecephysanalyzer_6_13 = channel.create()
ecephys_to_visualize_ecephys_14 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_preprocess_ecephys_si_1_to_capsule_spikesort_kilosort_25_ecephysanalyzer_7_15 = channel.create()
capsule_postprocess_ecephysanalyzer_5_to_capsule_unit_classifier_ecephysanalyzer_8_16 = channel.create()
capsule_job_dispatch_ecephys_4_to_capsule_collect_results_ecephysanalyzer_9_17 = channel.create()
capsule_preprocess_ecephys_si_1_to_capsule_collect_results_ecephysanalyzer_9_18 = channel.create()
capsule_spikesort_kilosort_25_ecephysanalyzer_7_to_capsule_collect_results_ecephysanalyzer_9_19 = channel.create()
capsule_postprocess_ecephysanalyzer_5_to_capsule_collect_results_ecephysanalyzer_9_20 = channel.create()
capsule_curate_ecephysanalyzer_2_to_capsule_collect_results_ecephysanalyzer_9_21 = channel.create()
capsule_unit_classifier_ecephysanalyzer_8_to_capsule_collect_results_ecephysanalyzer_9_22 = channel.create()
capsule_visualize_ecephysanalyzer_6_to_capsule_collect_results_ecephysanalyzer_9_23 = channel.create()
ecephys_to_collect_results_ecephys_24 = channel.fromPath(params.ecephys_url + "/", type: 'any')
ecephys_to_nwb_packaging_subject_capsule_25 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_nwb_packaging_ecephys_capsuleanalyzer_12_to_capsule_nwb_packaging_unitsanalyzer_11_26 = channel.create()
capsule_job_dispatch_ecephys_4_to_capsule_nwb_packaging_unitsanalyzer_11_27 = channel.create()
capsule_collect_results_ecephysanalyzer_9_to_capsule_nwb_packaging_unitsanalyzer_11_28 = channel.create()
ecephys_to_nwb_packaging_units_29 = channel.fromPath(params.ecephys_url + "/", type: 'any')
ecephys_to_nwb_packaging_ecephys_capsule_30 = channel.fromPath(params.ecephys_url + "/", type: 'any')
capsule_job_dispatch_ecephys_4_to_capsule_nwb_packaging_ecephys_capsuleanalyzer_12_31 = channel.create()
capsule_nwb_packaging_subject_capsule_10_to_capsule_nwb_packaging_ecephys_capsuleanalyzer_12_32 = channel.create()

// capsule - Preprocess Ecephys
process capsule_preprocess_ecephys_si_1 {
	tag 'capsule-4923505'
	container "$REGISTRY_HOST/capsule/068a0863-8576-45c4-827c-e53fd3e926a9:2fffef0c245ee1ba582c6bff5e204814"

	cpus 16
	memory '64 GB'

	input:
	path 'capsule/data/' from capsule_job_dispatch_ecephys_4_to_capsule_preprocess_ecephys_si_1_1.flatten()
	path 'capsule/data/ecephys_session' from ecephys_to_preprocess_ecephys_2.collect()

	output:
	path 'capsule/results/*' into capsule_preprocess_ecephys_si_1_to_capsule_postprocess_ecephysanalyzer_5_7
	path 'capsule/results/*' into capsule_preprocess_ecephys_si_1_to_capsule_visualize_ecephysanalyzer_6_10
	path 'capsule/results/*' into capsule_preprocess_ecephys_si_1_to_capsule_spikesort_kilosort_25_ecephysanalyzer_7_15
	path 'capsule/results/*' into capsule_preprocess_ecephys_si_1_to_capsule_collect_results_ecephysanalyzer_9_18

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=068a0863-8576-45c4-827c-e53fd3e926a9
	export CO_CPUS=16
	export CO_MEMORY=68719476736

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4923505.git" capsule-repo
	git -C capsule-repo checkout e76a6c01333f24ab2a77e21b4e0d3f31ffebbfec --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_preprocess_ecephys_si_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Curate Ecephys
process capsule_curate_ecephysanalyzer_2 {
	tag 'capsule-1970643'
	container "$REGISTRY_HOST/capsule/336d7f17-dd29-4f92-931b-1244f9479591:6bf9afe8980279cb350d9a01f7007e0f"

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/' from capsule_postprocess_ecephysanalyzer_5_to_capsule_curate_ecephysanalyzer_2_3

	output:
	path 'capsule/results/*' into capsule_curate_ecephysanalyzer_2_to_capsule_visualize_ecephysanalyzer_6_11
	path 'capsule/results/*' into capsule_curate_ecephysanalyzer_2_to_capsule_collect_results_ecephysanalyzer_9_21

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=336d7f17-dd29-4f92-931b-1244f9479591
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1970643.git" capsule-repo
	git -C capsule-repo checkout d5b0d03fa3e7924409deb7c981e8ed8521595bfe --quiet
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
process capsule_job_dispatch_ecephys_4 {
	tag 'capsule-5832718'
	container "$REGISTRY_HOST/capsule/cb734cf3-2f88-4b69-bf0a-d5869e6706e3:0a5784d58c455dc75510000189900809"

	cpus 4
	memory '32 GB'

	input:
	path 'capsule/data/ecephys_session' from ecephys_to_job_dispatch_ecephys_4.collect()

	output:
	path 'capsule/results/*' into capsule_job_dispatch_ecephys_4_to_capsule_preprocess_ecephys_si_1_1
	path 'capsule/results/*' into capsule_job_dispatch_ecephys_4_to_capsule_postprocess_ecephysanalyzer_5_8
	path 'capsule/results/*' into capsule_job_dispatch_ecephys_4_to_capsule_collect_results_ecephysanalyzer_9_17
	path 'capsule/results/*' into capsule_job_dispatch_ecephys_4_to_capsule_nwb_packaging_unitsanalyzer_11_27
	path 'capsule/results/*' into capsule_job_dispatch_ecephys_4_to_capsule_nwb_packaging_ecephys_capsuleanalyzer_12_31

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=cb734cf3-2f88-4b69-bf0a-d5869e6706e3
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5832718.git" capsule-repo
	git -C capsule-repo checkout 0571cf88b96b56059b8e5db5a0d1972ba09bbc76 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_job_dispatch_ecephys_4_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Postprocess Ecephys
process capsule_postprocess_ecephysanalyzer_5 {
	tag 'capsule-9905040'
	container "$REGISTRY_HOST/capsule/a1b18442-b9dc-4002-a2e6-a3941cafcb8a:70bfd5d5f093d96eb5d4da070a6060a3"

	cpus 16
	memory '128 GB'

	input:
	path 'capsule/data/ecephys_session' from ecephys_to_postprocess_ecephys_5.collect()
	path 'capsule/data/' from capsule_spikesort_kilosort_25_ecephysanalyzer_7_to_capsule_postprocess_ecephysanalyzer_5_6.collect()
	path 'capsule/data/' from capsule_preprocess_ecephys_si_1_to_capsule_postprocess_ecephysanalyzer_5_7.collect()
	path 'capsule/data/' from capsule_job_dispatch_ecephys_4_to_capsule_postprocess_ecephysanalyzer_5_8.flatten()

	output:
	path 'capsule/results/*' into capsule_postprocess_ecephysanalyzer_5_to_capsule_curate_ecephysanalyzer_2_3
	path 'capsule/results/*' into capsule_postprocess_ecephysanalyzer_5_to_capsule_visualize_ecephysanalyzer_6_13
	path 'capsule/results/*' into capsule_postprocess_ecephysanalyzer_5_to_capsule_unit_classifier_ecephysanalyzer_8_16
	path 'capsule/results/*' into capsule_postprocess_ecephysanalyzer_5_to_capsule_collect_results_ecephysanalyzer_9_20

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=a1b18442-b9dc-4002-a2e6-a3941cafcb8a
	export CO_CPUS=16
	export CO_MEMORY=137438953472

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9905040.git" capsule-repo
	git -C capsule-repo checkout dbb92ec607a8f7b3e820643e97722c9c2b64e061 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_postprocess_ecephysanalyzer_5_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Visualize Ecephys
process capsule_visualize_ecephysanalyzer_6 {
	tag 'capsule-0353569'
	container "$REGISTRY_HOST/capsule/ddadedc6-7614-4403-a50b-59b86be99aed:9936010c112ef4143e59c6432b61e89c"

	cpus 8
	memory '64 GB'

	input:
	path 'capsule/data/' from capsule_unit_classifier_ecephysanalyzer_8_to_capsule_visualize_ecephysanalyzer_6_9.collect()
	path 'capsule/data/' from capsule_preprocess_ecephys_si_1_to_capsule_visualize_ecephysanalyzer_6_10
	path 'capsule/data/' from capsule_curate_ecephysanalyzer_2_to_capsule_visualize_ecephysanalyzer_6_11.collect()
	path 'capsule/data/' from capsule_spikesort_kilosort_25_ecephysanalyzer_7_to_capsule_visualize_ecephysanalyzer_6_12.collect()
	path 'capsule/data/' from capsule_postprocess_ecephysanalyzer_5_to_capsule_visualize_ecephysanalyzer_6_13.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_visualize_ecephys_14.collect()

	output:
	path 'capsule/results/*' into capsule_visualize_ecephysanalyzer_6_to_capsule_collect_results_ecephysanalyzer_9_23

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=ddadedc6-7614-4403-a50b-59b86be99aed
	export CO_CPUS=8
	export CO_MEMORY=68719476736

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0353569.git" capsule-repo
	git -C capsule-repo checkout c8c467914cf31bfdea0988fb9feef591a5f81d7c --quiet
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
process capsule_spikesort_kilosort_25_ecephysanalyzer_7 {
	tag 'capsule-9014385'
	container "$REGISTRY_HOST/capsule/2a67f9f1-8f9c-441a-81c2-f60dc648719a:bdc82702080a9c36c0e38dc1743b457d"

	cpus 16
	memory '61 GB'
	accelerator 1
	label 'gpu'

	input:
	path 'capsule/data/' from capsule_preprocess_ecephys_si_1_to_capsule_spikesort_kilosort_25_ecephysanalyzer_7_15

	output:
	path 'capsule/results/*' into capsule_spikesort_kilosort_25_ecephysanalyzer_7_to_capsule_postprocess_ecephysanalyzer_5_6
	path 'capsule/results/*' into capsule_spikesort_kilosort_25_ecephysanalyzer_7_to_capsule_visualize_ecephysanalyzer_6_12
	path 'capsule/results/*' into capsule_spikesort_kilosort_25_ecephysanalyzer_7_to_capsule_collect_results_ecephysanalyzer_9_19

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=2a67f9f1-8f9c-441a-81c2-f60dc648719a
	export CO_CPUS=16
	export CO_MEMORY=65498251264

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9014385.git" capsule-repo
	git -C capsule-repo checkout f3075d2b6d913eb3f5721abc2db689f435cd83f4 --quiet
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
process capsule_unit_classifier_ecephysanalyzer_8 {
	tag 'capsule-3127167'
	container "$REGISTRY_HOST/capsule/58eeb71f-c3ae-4ff7-86a6-e459c7d14531:d300eec385eec1c916ee223b2dade0c1"

	cpus 8
	memory '64 GB'

	input:
	path 'capsule/data/' from capsule_postprocess_ecephysanalyzer_5_to_capsule_unit_classifier_ecephysanalyzer_8_16

	output:
	path 'capsule/results/*' into capsule_unit_classifier_ecephysanalyzer_8_to_capsule_visualize_ecephysanalyzer_6_9
	path 'capsule/results/*' into capsule_unit_classifier_ecephysanalyzer_8_to_capsule_collect_results_ecephysanalyzer_9_22

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=58eeb71f-c3ae-4ff7-86a6-e459c7d14531
	export CO_CPUS=8
	export CO_MEMORY=68719476736

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3127167.git" capsule-repo
	git -C capsule-repo checkout c3c36edab9cc1383ac1ed1d1e0285aabfcd50147 --quiet
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
process capsule_collect_results_ecephysanalyzer_9 {
	tag 'capsule-3835238'
	container "$REGISTRY_HOST/capsule/f90798b1-7e64-49e1-947e-4c94c07f8bbf:372c5d68a026144ae41a44f9c5596f32"

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_job_dispatch_ecephys_4_to_capsule_collect_results_ecephysanalyzer_9_17.collect()
	path 'capsule/data/' from capsule_preprocess_ecephys_si_1_to_capsule_collect_results_ecephysanalyzer_9_18.collect()
	path 'capsule/data/' from capsule_spikesort_kilosort_25_ecephysanalyzer_7_to_capsule_collect_results_ecephysanalyzer_9_19.collect()
	path 'capsule/data/' from capsule_postprocess_ecephysanalyzer_5_to_capsule_collect_results_ecephysanalyzer_9_20.collect()
	path 'capsule/data/' from capsule_curate_ecephysanalyzer_2_to_capsule_collect_results_ecephysanalyzer_9_21.collect()
	path 'capsule/data/' from capsule_unit_classifier_ecephysanalyzer_8_to_capsule_collect_results_ecephysanalyzer_9_22.collect()
	path 'capsule/data/' from capsule_visualize_ecephysanalyzer_6_to_capsule_collect_results_ecephysanalyzer_9_23.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_collect_results_ecephys_24.collect()

	output:
	path 'capsule/results/*'
	path 'capsule/results/*' into capsule_collect_results_ecephysanalyzer_9_to_capsule_nwb_packaging_unitsanalyzer_11_28

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=f90798b1-7e64-49e1-947e-4c94c07f8bbf
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3835238.git" capsule-repo
	git -C capsule-repo checkout 4c7cde8cb8f6c17448d2d11df355d2f361f2f0db --quiet
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
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_packaging_subject_capsule_25.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_subject_capsule_10_to_capsule_nwb_packaging_ecephys_capsuleanalyzer_12_32

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
	git -C capsule-repo checkout 209bacfe6769c88237084dde836e2a88eefe62b3 --quiet
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
process capsule_nwb_packaging_unitsanalyzer_11 {
	tag 'capsule-6487550'
	container "$REGISTRY_HOST/capsule/0594f14e-9295-4360-b41e-103d181ccd85:0f1e7e9fee86de21c6cb2b869e33aea4"

	cpus 4
	memory '32 GB'

	publishDir "$RESULTS_PATH/nwb", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_nwb_packaging_ecephys_capsuleanalyzer_12_to_capsule_nwb_packaging_unitsanalyzer_11_26.collect()
	path 'capsule/data/' from capsule_job_dispatch_ecephys_4_to_capsule_nwb_packaging_unitsanalyzer_11_27.collect()
	path 'capsule/data/' from capsule_collect_results_ecephysanalyzer_9_to_capsule_nwb_packaging_unitsanalyzer_11_28.collect()
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_packaging_units_29.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=0594f14e-9295-4360-b41e-103d181ccd85
	export CO_CPUS=4
	export CO_MEMORY=34359738368

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6487550.git" capsule-repo
	git -C capsule-repo checkout 9ecf2e5e155d0821cd03b76b87c241143c4d6e7b --quiet
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
process capsule_nwb_packaging_ecephys_capsuleanalyzer_12 {
	tag 'capsule-1293912'
	container "$REGISTRY_HOST/capsule/2c6ff3dd-a1e0-4376-968d-73e506146027:8e39e5e1d6bd562dfc7cdcae8af54a7d"

	cpus 8
	memory '64 GB'

	input:
	path 'capsule/data/ecephys_session' from ecephys_to_nwb_packaging_ecephys_capsule_30.collect()
	path 'capsule/data/' from capsule_job_dispatch_ecephys_4_to_capsule_nwb_packaging_ecephys_capsuleanalyzer_12_31.collect()
	path 'capsule/data/' from capsule_nwb_packaging_subject_capsule_10_to_capsule_nwb_packaging_ecephys_capsuleanalyzer_12_32.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_ecephys_capsuleanalyzer_12_to_capsule_nwb_packaging_unitsanalyzer_11_26

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=2c6ff3dd-a1e0-4376-968d-73e506146027
	export CO_CPUS=8
	export CO_MEMORY=68719476736

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1293912.git" capsule-repo
	git -C capsule-repo checkout 80753973f6b2354780bd54f169be102635109b15 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_nwb_packaging_ecephys_capsuleanalyzer_12_args}

	echo "[${task.tag}] completed!"
	"""
}
