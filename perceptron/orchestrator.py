from random import seed
from random import gauss
from random import randrange
import numpy as np
from configparser import ConfigParser
import utility as util
import matplotlib.pyplot as plt
from perceptron import Perceptron


def run_perceptron(conf, sampleSize, dimensions, alpha, Nd, N_max):
    mean = conf.getint("mean")
    std = conf.getint("std")
    np.random.seed(conf.getint("random_seed"))
    #######################################################################################################################
    #  INITIALIZING THE INPUT DATA
    #######################################################################################################################
    success = 0
    for n in range(Nd):
        p = util.generate_n_dim_gaussian(dimensions, sampleSize, mean, std)
        print(util.print_heading("INPUT DATA SUMMARY"))
        print("The mean of the input vector = ", p.mean())
        print("The std of the input vector = ", p.std())

        # Initialize the labels
        labels = np.random.choice([-1, 1], size=sampleSize, p=[.5, .5])
        x = np.where(labels > 0)
        print("Number labels with +1 = ", np.size(x))
        y = np.where(labels < 0)
        print("Number labels with +1 = ", np.size(y))
        print(util.print_heading())

        pr = Perceptron(conf.getfloat("learning_rate"), conf.getint("epochs"))
        success = success + pr.train(p, labels)

    return success/Nd
