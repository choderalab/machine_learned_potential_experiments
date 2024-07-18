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
potentials=("ani2x" "painn" "sake" "schnet" "physnet")
datasets=("ani2x" "spice2" "qm9" "phalkethoh")

# Iterate through each potential
for potential in "${potentials[@]}"; do
    # Iterate through each dataset
    for dataset in "${datasets[@]}"; do
        # Repeat each training 3 times
        for run in {1..3}; do
            echo "Running training for potential: $potential, dataset: $dataset, run: $run"
            # Construct the python command
            python_cmd="python ../../scripts/perform_training.py \
            --potential_path=\"../../configs/potentials/${potential}.toml\" \
            --dataset_path=\"../../configs/datasets/${dataset}.toml\" \
            --training_path=\"configs/training.toml\"
            --runtime_path=\"configs/runtime.toml\""

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
