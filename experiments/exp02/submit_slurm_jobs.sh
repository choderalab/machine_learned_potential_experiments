#!/bin/bash

# Example usage: sbatch submit_slurm_jobs.sh --accelerator 'gpu' --device [2]

# Parse command-line arguments for optional accelerator and device
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --accelerator) accelerator="$2"; shift ;;
        --device) device="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Define arrays for potentials and datasets
potential_config_dir="v0_published"
experiment_name="exp02"
potentials=("ani2x" "painn" "sake" "schnet" "physnet" "aimnet2")
datasets=("phalkethoh")

# Iterate through each potential
for potential in "${potentials[@]}"; do
    # Iterate through each dataset
    for dataset in "${datasets[@]}"; do
        # Construct the job name
        job_name="${potential}_${dataset}"
        echo "Submitting training job for potential: $potential, dataset: $dataset"

        # Construct the python command
        python_cmd="python ../scripts/perform_training.py \
		--potential_parameter_path=\"../../configs/potentials/${potential_config_dir}/${potential}.toml\" \
		--dataset_parameter_path=\"../../configs/datasets/${dataset}.toml\" \
		--training_parameter_path=\"configs/training.toml\" \
		--runtime_parameter_path=\"configs/runtime.toml\""

        # Add optional accelerator and device arguments if provided
        if [ -n "$accelerator" ]; then
            python_cmd+=" --accelerator=\"$accelerator\""
        fi
        if [ -n "$device" ]; then
            python_cmd+=" --device=\"$device\""
        fi

        # Submit the job via slurm
	sbatch --job-name=$job_name \
		--partition=gpu \
		--nodes=1 \
		--ntasks-per-node=1 \
		--cpus-per-task=1 \
		--mem-per-cpu=16G \
		--gres=gpu:a100:1 \
		--time=20:00:00 \
		--output=%j_%x_%N.out \
		--error=%j_%x_%N.err << EOF
#!/bin/bash
source ${HOME}/.bashrc

# Activate environment
mamba activate mf-train

# Report node in use
hostname

# Disable NCC
export NCCL_P2P_DISABLE=1

# Report CUDA info
env | sort | grep 'CUDA'

# Report GPUs available
nvidia-smi

# Execute the python command
pwd
srun $python_cmd
EOF

    done
done
