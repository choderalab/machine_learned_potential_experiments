#!/bin/bash

# example usage: bash train.sh --accelerator 'gpu' --device [2]

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
potentials=( "schnet")
# potentials=( "ani2x" "painn" "schnet" "physnet" "tensornet" "sake" "aimnet2")
datasets=( "tmqm")
potential_version=( "v2")
training_config=( "training_v2")
#training_config=( "training_v1" "training_v2" "training_v3")

for potential_ver in "${potential_version[@]}"; do
    # Iterate through each potential
    for potential in "${potentials[@]}"; do
        # Iterate through each dataset
        for dataset in "${datasets[@]}"; do
            for training_conf in "${training_config[@]}"; do
                echo "Running training for potential: $potential, dataset: $dataset, run: $run"
                # Construct the python command
                python_cmd="python ../../scripts/perform_training.py \
        --potential_parameter_path=\"../../configs/potentials/${potential_ver}/${potential}.toml\" \
        --dataset_parameter_path=\"../../configs/datasets/${dataset}.toml\" \
        --training_parameter_path=\"configs/${training_conf}.toml\" \
        --runtime_parameter_path=\"configs/runtime.toml\""

                    # Add optional accelerator and device arguments if provided
                    if [ -n "$accelerator" ]; then
                        python_cmd+=" --accelerator=\"$accelerator\""
                    fi
                    if [ -n "$device" ]; then
                        python_cmd+=" --device=\"$device\""
                    fi

                    # Execute the python command
                    echo $python_cmd
                    eval $python_cmd
            done
        done
    done
done
