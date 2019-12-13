import numpy as np

class Perceptron:
    def __init__(self, learning_rate=0.01, epochs=10):
        self.learning_rate = learning_rate
        self.epochs = epochs

    def train(self, data, labels):
        # Tabula rasa's, at t = 0 w(t) = 0
        weights = np.zeros(data.shape[1], )
        for t in range(self.epochs):
            for indx, rec in enumerate(data):
                data[:,0] = data[:,0]*labels
                data[:,1] = data[:,1]*labels
                Emu = np.sum(np.dot(data, np.transpose(weights))) <= 0
                print("CHECK for correctness - PART C; TODO, make 1/10 generic")
                for w_indx, w in enumerate(weights):
                    if Emu:
                        weights = weights + (1/10) * data
                    else:
                        weights = weights

        return weights
