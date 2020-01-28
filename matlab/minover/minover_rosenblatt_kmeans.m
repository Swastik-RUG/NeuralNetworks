clc;
clear;
lambdas = [0.0];
alphas = 0.1:0.1:5;
% Dimension, change to increase size of P
N = 100;
itr = 100; % Nd - dimensions
epochs = 100; % Nmax
rng(100);
USE_STATE_STORE = 1;

minover_vs_rosenblatt_vs_kmeans_statestore = 'state_store/minover_vs_rosenblatt_vs_kmeans.mat';
if isfile(minover_vs_rosenblatt_vs_kmeans_statestore) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    deviations_base_minover = importdata(minover_vs_rosenblatt_vs_kmeans_statestore, 'deviations_base_minover').deviations_base_minover;
    deviations_base_rosenblatt = importdata(minover_vs_rosenblatt_vs_kmeans_statestore, 'deviations_base_rosenblatt').deviations_base_rosenblatt;
    deviations_base_kmeans = importdata(minover_vs_rosenblatt_vs_kmeans_statestore, 'deviations_base_kmeans').deviations_base_kmeans;

else
    deviations_base_minover = zeros(length(lambdas), length(alphas));
    for i=1:length(lambdas)
        for j=1:length(alphas)
            alpha = alphas(j);
            lambda = lambdas(i);
            %[success, results] = run_perceptron(alpha, N, epochs, itr, c);
            [deviations_base_minover(i, j), ~] = run_minover(alpha, N, epochs, itr, lambda, 0);
            [deviations_base_rosenblatt(i, j), ~] = run_perceptron(alpha, N, epochs, itr, 0.0, lambda, 0);
            [deviations_base_kmeans(i, j)] = run_kmeans(alpha, N, epochs, itr, 0.0, lambda, 0);
        end
    end
    save(minover_vs_rosenblatt_vs_kmeans_statestore, 'deviations_base_minover', 'deviations_base_rosenblatt', 'deviations_base_kmeans');
end

figure('NumberTitle', 'off', 'Name', "Minover vs Rosenblatts based on different noise levels",'units','normalized','outerposition',[0 0 1 1])
legends = {};
for indx=1:size(deviations_base_minover,1)
    plot(alphas, deviations_base_minover, 'm-^');
    legends = [legends; sprintf("Minover|Lambda = %.1f", lambdas(indx))];
    hold on;
    plot(alphas, deviations_base_rosenblatt, 'r-o');
    legends = [legends; sprintf("Rosenblatt|Lambda = %.1f", lambdas(indx))];
    hold on;
    plot(alphas, deviations_base_kmeans, 'b-*');
    legends = [legends; sprintf("Kmeans|Lambda = %.1f", lambdas(indx))];
    hold on;
end
title('Minover vs Rosenblatts vs Kmeans [Generalization Error]', "FontSize", 24);
ax = gca;
ax.FontSize = 16;
xlabel('Alpha = P/N', "FontSize", 20);
ylabel('Generalization Error',"FontSize", 20);
legend(legends,'Location', 'northeast')
text(4.3, 0.37, "Dimensions = 100", "FontSize", 16)
text(4.3, 0.35, "Epochs = 100", "FontSize", 16)
text(4.3, 0.33, "Iterations = 100", "FontSize", 16)