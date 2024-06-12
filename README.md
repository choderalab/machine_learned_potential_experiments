# Experiments
Perform experiments with modelforge

Each experiment is performed and saved in the `experiments` directory. Each experiment has a descriptive name and contains config files inside the configs folder to reproduce the experiment. For each experiment, we provide a descriptive README file, and a bash script reproducing the experiment on a single node and GPU (this might differ from how we run the experiment in practice). 
As result, we provide test/validation set RMSE, training curve (MSE), training rate scheduling and number of epochs.


The folder structure looks like follows:
```
experiments
- train_on_nergies # name of the experiment
  - configs # define the training, deposit all toml files for dataset/potential that differ from the default values 
    - training.toml
  - README # describe why this experiment is performed, and what is performed
  - train.sh # reproduces the experiment on a single node/GPU

```
