import numpy as np


class Perceptron:
    def __init__(self, learning_rate=0.01, epochs=10):
        self.learning_rate = learning_rate
        self.epochs = epochs

    def train(self, data, labels):
        # Tabula rasa's, at t = 0 w(t) = 0
        column_count = data.shape[1]
        row_count = data.shape[0]
        weights = np.zeros((1, column_count))
        convergence = 0
        for t in range(self.epochs):

            for row_indx in range(row_count):
                Emu = np.dot(weights, data[row_indx]) * labels[row_indx]
                if Emu <= 0.0:
                    weights = weights + (1 / column_count) * (data[row_indx] * labels[row_indx])

            convergence = np.sum(np.sign(np.sum(weights * data, 1)).astype(int) == labels)
            if convergence == 0:
                break

        return weights * data, convergence/row_count, row_count-convergence
