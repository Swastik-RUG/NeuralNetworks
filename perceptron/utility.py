import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA

def print_heading(str="", dashes=50):
    return "-" * (dashes - int(len(str) / 2)) + str + "-" * (dashes - int(len(str) / 2))


def generate_n_dim_gaussian(N=2, sampleSize=1000, mean=0, std=1):
    res = np.zeros(shape=(sampleSize, N))
    for i in range(1, N + 1):
        res[:, i - 1] = np.random.normal(mean, std, sampleSize)
    return res

def PCA_reduction(data):
    x = data.iloc[:, 0:3].values
    y = data.iloc[:, 3].values
    x = StandardScaler().fit_transform(x)
    pca = PCA(n_components=2)
    principalComponents = pca.fit_transform(x)
    finalres = pd.DataFrame(data = principalComponents, columns = ['principal component 1', 'principal component 2'])
    return finalres

def tupleToNdArray(tup):
    res = []
    for i in range(1, len(tup)):
        res.append(tup[i])
    return res