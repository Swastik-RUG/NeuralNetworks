import numpy as np

class Perceptron:
    def __init__(self, learning_rate=0.01, epochs=10):
        self.learning_rate = learning_rate
        self.epochs = epochs

    def train(self, data, labels):
        # Tabula rasa's, at t = 0 w(t) = 0
        weights = np.zeros((data.shape[0],data.shape[1]) )
        for t in range(self.epochs):
            for indx, rec in enumerate(data):
                Emu = np.sum(np.dot(rec*labels[indx], weights[indx]))
                print("CHECK for correctness - PART C; TODO, make 1/10 generic")
                # TODO: !!!!!!!!!! NEED TO IMPLEMENT Emu > 0 stop condition!!!!!!!!!!
                for w_indx, w in enumerate(weights):
                    if Emu <= 0:
                        weights[indx] = weights[indx] + (1/np.size(rec, 0)) * rec
                    else:
                        weights[indx] = weights[indx]

        return weights
