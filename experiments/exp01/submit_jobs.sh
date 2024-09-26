#!/bin/bash

# Example usage: bash submit_jobs.sh --accelerator 'gpu' --device [2]

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
potentials=("ani2x" "painn" "sake" "schnet" "physnet" "aimnet2" "tensornet")
datasets=("phalkethoh")

# Iterate through each potential
for potential in "${potentials[@]}"; do
    # Iterate through each dataset
    for dataset in "${datasets[@]}"; do
        # Construct the job name
        job_name="${potential}_${dataset}"
        echo "Submitting training job for potential: $potential, dataset: $dataset"

        # Construct the python command
        python_cmd="python ../../scripts/perform_training.py \
--potential_parameter_path=\"../../configs/potentials/${potential}.toml\" \
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

        # Submit the job via bsub
        bsub -P "train_potential" \
             -J "$job_name" \
             -n 8 \
             -R "rusage[mem=32]" \
             -R "span[hosts=1]" \
             -q "gpuqueue" \
             -gpu "num=1:j_exclusive=yes:mode=shared" \
             -W "12:00" \
             -o "out_%J_%I.stdout" \
             -eo "out_%J_%I.stderr" \
             -L "/bin/bash" << EOF

#!/bin/bash
source ~/.bashrc
# Activate your environment if needed
mamba activate modelforge

# Execute the python command
$python_cmd
EOF

    done
done
