#!/bin/bash

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
            python ../../scripts/perform_training.py \
            --potential_path="../../configs/potential_${potential}.toml" \
            --dataset_path="../../configs/dataset_${dataset}.toml" \
            --training_path="../../configs/training.toml"
        done
    done
done
