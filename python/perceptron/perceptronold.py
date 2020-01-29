import numpy as np


class PerceptronOld:
    def __init__(self, learning_rate=0.01, epochs=10):
        self.learning_rate = learning_rate
        self.epochs = epochs

    def train(self, data, labels):
        # Tabula rasa's, at t = 0 w(t) = 0
        weights = np.zeros((data.shape[0], data.shape[1]))
        Ev = 0;
        for t in range(self.epochs):
            if np.sum(Ev) < 1:
                # for indx, rec in enumerate(data):

                for w_indx, w in enumerate(weights):
                    Emu = np.sum(np.dot(data[w_indx] * labels[w_indx], weights[w_indx]))
                    if Emu <= 0:
                        weights[w_indx] = weights[w_indx] + (1 / np.size(data[w_indx], 0)) * data[w_indx]
                    else:
                        weights[w_indx] = weights[w_indx]

                Ev += np.sum(weights)
            else:
                return weights
        return weights
