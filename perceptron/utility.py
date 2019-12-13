import numpy as np

def printHeading(str="", dashes=50):
    return "-" * (dashes - int(len(str)/2)) + str + "-" * (dashes - int(len(str)/2))

def generateNDGaussian(N=2, sampleSize = 1000):
    res = np.zeros(shape=(sampleSize, N))
    for i in range(1, N+1):
        res[:, i-1] = np.random.normal(0, 1, sampleSize)
    return  res