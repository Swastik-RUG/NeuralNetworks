from random import seed
from random import gauss
from random import randrange
import numpy as np
from configparser import ConfigParser
import utility as util
import matplotlib.pyplot as plt
from perceptron import Perceptron


def run_perceptron(conf, sampleSize, alpha):
    mean = conf.getint("mean")
    std = conf.getint("std")
    dimensions = conf.getint("dimensions")

    #######################################################################################################################
    #  INITIALIZING THE INPUT DATA
    #######################################################################################################################

    # sampleSize = conf.getint("vector_size")
    np.random.seed(conf.getint("random_seed"))
    # Initialize the sample vector
    p = util.generate_n_dim_gaussian(dimensions, sampleSize, mean, std)
    print(util.print_heading("INPUT DATA SUMMARY"))
    print("The mean of the input vector = ", p.mean())
    print("The std of the input vector = ", p.std())
    #assert (conf.getboolean("disable_assertion") or p.mean() == conf.getfloat("expected_mean"))
    #assert (conf.getboolean("disable_assertion") or p.std() == conf.getfloat("expected_std"))

    # Initialize the labels
    labels = np.random.choice([-1, 1], size=sampleSize, p=[.5, .5])
    x = np.where(labels > 0)
    print("Number labels with +1 = ", np.size(x))
    y = np.where(labels < 0)
    print("Number labels with +1 = ", np.size(y))
    #assert (conf.getboolean("disable_assertion") or np.size(x) == conf.getint("label_1"))
    #assert (conf.getboolean("disable_assertion") or np.size(y) == conf.getint("label_2"))
    print(util.print_heading())

    training_data = np.vstack((p[:, 0], p[:, 1], labels))
    train_label1_indx = np.where(training_data[2] > 0)
    train_label2__indx = np.where(training_data[2] < 1)

    data_i = (p[train_label1_indx], p[train_label2__indx])
    colors_i = ("red", "blue")
    groups_i = ("labbel1", "label2")

    # Create plot
    # fig = plt.figure("Input alpha=" + alpha)
    # ax = fig.add_subplot(1, 1, 1)
    #
    # for data, color, group in zip(data, colors, groups):
    #     ax.scatter(data[:, 0], data[:, 1], alpha=0.8, c=color, edgecolors='none', s=30, label=group)
    #
    # plt.title('Input vector scatter plot alpha=:' + alpha)

    pr = Perceptron(conf.getfloat("learning_rate"), conf.getint("epochs"))
    trained = pr.train(p, labels)

    training_data = np.vstack((trained[:, 0], trained[:, 1], labels))
    train_label1_indx = np.where(training_data[2] > 0)
    train_label2__indx = np.where(training_data[2] < 1)

    data = (trained[train_label1_indx], trained[train_label2__indx])
    colors = ("red", "blue")
    groups = ("labbel1", "label2")

    # Create plot
    #fig = plt.figure("output alpha=" + alpha)
    # ax = fig.add_subplot(1, 1, 1)
    #
    # for data, color, group in zip(data, colors, groups):
    #     ax.scatter(data[:, 0], data[:, 1], alpha=0.8, c=color, edgecolors='none', s=30, label=group)

   # plt.title('Weights After training alpha=:' + alpha)
    #plt.show()

    fig = plt.figure("output alpha=" + alpha)
    plt.subplot(1, 2, 1)

    for data_i, color_i, group_i in zip(data_i, colors_i, groups_i):
        plt.scatter(data_i[:, 0], data_i[:, 1], alpha=0.8, c=color_i, edgecolors='none', s=30, label=group_i)
    plt.title('Input vector scatter plot alpha=:' + alpha)

    plt.subplot(1, 2, 2)
    for data, color, group in zip(data, colors, groups):
        plt.scatter(data[:, 0], data[:, 1], alpha=0.8, c=color, edgecolors='none', s=30, label=group)

    plt.title('Weights After training alpha=:' + alpha)
