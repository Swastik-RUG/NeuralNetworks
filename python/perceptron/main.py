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
    Nd = cnf.getint("Nd")
    N_max = cnf.getint("N_max")
    success_ratio = run_perceptron(cnf, p,cnf.getint("dimensions"), str(cnf.getfloat("alpha")), Nd, N_max)
    alphaValues.append(cnf.getfloat("alpha"))
    convergenceByAlpha.append(success_ratio)


fig = plt.figure("Alpha vs Convergences")
plt.plot(alphaValues, convergenceByAlpha)
plt.show()
