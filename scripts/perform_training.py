if __name__ == "__main__":

    import fire
    from modelforge.train.training import read_config_and_train

    fire.Fire(read_config_and_train)
