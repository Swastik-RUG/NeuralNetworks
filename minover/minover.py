import numpy as np
import matplotlib.pyplot as plt

# number of dimensions
N = 20
# max number of epochs
n_max = 100
# number of times we re-generate the data end re-run the perceptron
nd = 100
# 0.25, 0.5, 0.75, . . . 3.0
#alphas = [0.1, 0.2, 0.25, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75, 0.9, 1.0, 1.2, 1.5, 1.7, 2.0, 2.2, 2.5, 2.7, 3.0]
alphas = np.arange(start=0.1, stop=10, step=0.1)
misclassifications = np.zeros((len(alphas),2))

for itr in range(len(alphas)):
    alpha = alphas[itr]
    p = round(alpha*N).astype(int)
    mean_error = 0
    for i in range(nd):
        wt = np.ones((1, N))

        data = np.random.randn(p,N)
        # Teacher perceptron
        labels = np.sign(np.dot(wt,np.transpose(data)))[0]

        weight = np.zeros((1, N))

        convergence = 0

        prev_min = 999

        for epoch in range(n_max):
            x = (np.dot(weight,np.transpose(data))* labels)[0]
            sorted_x = np.sort(x)
            sort_indx = np.argsort(x)

            new_min = sorted_x[0]

            min = data[sort_indx[0], :]
            min_label = labels[sort_indx[0]]

            weight = weight + (1/N)*(min*min_label)

            if new_min < prev_min:
                prev_min = new_min
                convergence = 0
            else:
                convergence = convergence + 1
                if convergence >= p:
                    break
        error = (1/np.pi) * np.arccos(np.dot(weight,np.transpose(wt))/np.dot(np.linalg.norm(weight),np.linalg.norm(wt)))[0]

        mean_error = mean_error+error

    mean_error = mean_error/nd
    misclassifications[itr,0] = alpha
    misclassifications[itr,1] = mean_error

fig = plt.figure("Alpha vs Convergences")
plt.plot(misclassifications[:,0], misclassifications[:,1])
plt.show()





