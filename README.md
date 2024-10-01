# Machine Learned Potential Experiments

Perform experiments with modelforge

## Overview

This repository contains experiments with machine-learned potentials using the modelforge framework. Each experiment is structured and saved within the experiments directory. The experiments are reproducible, with configuration files and detailed documentation provided for each.


## Folder structure

The folder structure for experiments is organized as follows:
```
experiments
- name_of_the_experiment 
  - config # define the training, deposit all toml files for dataset/potential that differ from the default values 
    - training.toml
  - README # describe why this experiment is performed, and what is performed
  - train.sh # reproduces the experiment on a single node/GPU

```
## Experiments
Each experiment includes:

- Config files: Define training parameters and hyperparameters.
- README files: Provide detailed descriptions of the experiment.
- Bash scripts: Reproduce the experiment on a single node/GPU.
- Results: Include test/validation set RMSE, training curve (MSE), training rate scheduling, and the number of epochs.

All experiments use the main branch of the modelforge repository, with the commit hash included to ensure reproducibility.

## Configurations

Dataset and potential hyperparameters are defined within the configs directory. Each experiment's specific parameters are documented and saved accordingly.

## Training framework

Experiments are performed using PyTorch Lightning, with progress tracked via W&B. 
The W&B repository is linked to each experiment.



