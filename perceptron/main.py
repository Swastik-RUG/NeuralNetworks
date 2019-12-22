from random import seed
from random import gauss
from random import randrange
import numpy as np
from configparser import ConfigParser
import utility as util
import matplotlib.pyplot as plt
from perceptronold import PerceptronOld
from  orchestrator import run_perceptron

parser = ConfigParser()
parser.read("conf.ini")
conf = parser["perceptron"]
simulations = conf.get("to_run").replace("\"", "").split(';')
alphaValues = []
convergenceByAlpha = []
for simulation in simulations:
    #simulation = simulations(i)
    cnf = parser[simulation]
    p = int(cnf.getfloat("alpha")*cnf.getint("dimensions"))
    training_data, convergence, misclassified = run_perceptron(cnf, p, str(cnf.getfloat("alpha")))
    alphaValues.append(cnf.getfloat("alpha"))
    convergenceByAlpha.append(convergence)

fig = plt.figure("Alpha vs Convergences")
plt.plot(alphaValues, convergenceByAlpha)
plt.show()
