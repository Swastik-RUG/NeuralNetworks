import numpy as np


def print_heading(str="", dashes=50):
    return "-" * (dashes - int(len(str) / 2)) + str + "-" * (dashes - int(len(str) / 2))


def generate_n_dim_gaussian(N=2, sampleSize=1000, mean=0, std=1):
    res = np.zeros(shape=(sampleSize, N))
    for i in range(1, N + 1):
        res[:, i - 1] = np.random.normal(mean, std, sampleSize)
    return res
