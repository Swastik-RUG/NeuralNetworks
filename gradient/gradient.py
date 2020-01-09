from scipy.io import loadmat

data = loadmat("inputs/data3.mat")
tau = data.get('tau')
xi = data.get('xi')

learning_rate = 0.05

epochs = 100

# Percentage of data to be retained for training and 1-p is for testing
p = 0.9


