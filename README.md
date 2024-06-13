# Experiments
Perform experiments with modelforge

Each experiment is performed and saved in the `experiments` directory. Each experiment has a descriptive name and contains config files inside the configs folder to reproduce the experiment. For each experiment, we provide a descriptive README file, and a bash script reproducing the experiment on a single node and GPU (this might differ from how we run the experiment in practice). 
As a result, we provide test/validation set RMSE, training curve (MSE), training rate scheduling, and the number of epochs.

Note: we always train with the main branch of the `modelforge` repository. To make sure that we are able to reproduce the training code we will add the commit hash of the current `main` branch to each training.


The folder structure looks like the following:
```
experiments
- name_of_the_experiment 
  - config # define the training, deposit all toml files for dataset/potential that differ from the default values 
    - training.toml
  - README # describe why this experiment is performed, and what is performed
  - train.sh # reproduces the experiment on a single node/GPU

```
