from random import seed
from random import gauss
from random import randrange
import numpy as np
from configparser import ConfigParser
import utility as util
import matplotlib.pyplot as plt
from perceptron import Perceptron
from  orchestrator import run_perceptron

parser = ConfigParser()
parser.read("conf.ini")
conf = parser["perceptron"]
simulations = conf.get("to_run").replace("\"", "").split(';')
for simulation in simulations:
    #simulation = simulations(i)
    cnf = parser[simulation]
    p = int(cnf.getfloat("alpha")*cnf.getint("dimensions"))
    run_perceptron(cnf, p, str(cnf.getfloat("alpha")))
plt.show()
