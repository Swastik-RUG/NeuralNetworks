clc;
clear;
lambdas = 0.0:0.1:0.5;
alphas = 0.1:0.1:5;
% Dimension, change to increase size of P
N = 100;
itr = 50; % Nd - dimensions
epochs = 100; % Nmax
rng(100);
USE_STATE_STORE = 1;

minover_vs_rosenblatt_lambdas_statestore = 'state_store/minover_vs_rosenblatt_lambdas.mat';
if isfile(minover_vs_rosenblatt_lambdas_statestore) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    deviations_base_minover = importdata(minover_vs_rosenblatt_lambdas_statestore, 'deviations_base_minover').deviations_base_minover;
    deviations_base_rosenblatt = importdata(minover_vs_rosenblatt_lambdas_statestore, 'deviations_base_rosenblatt').deviations_base_rosenblatt;
else
    deviations_base_minover = zeros(length(lambdas), length(alphas));
    for i=1:length(lambdas)
        for j=1:length(alphas)
            alpha = alphas(j);
            lambda = lambdas(i);
            %[success, results] = run_perceptron(alpha, N, epochs, itr, c);
            rng(100);
            deviations_base_minover(i, j) = run_minover(alpha, N, epochs, itr, lambda, 0);
            rng(100);
            deviations_base_rosenblatt(i, j) = run_perceptron(alpha, N, epochs, itr, 0.0, lambda, 0);
        end
    end
    save(minover_vs_rosenblatt_lambdas_statestore, 'deviations_base_minover', 'deviations_base_rosenblatt');
end

figure('NumberTitle', 'off', 'Name', "Minover vs Rosenblatts based on different noise levels",'units','normalized','outerposition',[0 0 1 1])
hold on;
for indx=1:size(deviations_base_minover,1)
    plot(alphas, deviations_base_minover(indx,:), '-^','DisplayName',sprintf("Minover|Lambda = %.1f", lambdas(indx)));
    plot(alphas, deviations_base_rosenblatt(indx,:), '-o','DisplayName',sprintf("Rosenblatt|Lambda = %.1f", lambdas(indx)));
end
hold off;

title('Minover vs Rosenblatts based on different Noise (lambda) levels', "FontSize", 24);
xlabel('Alpha = P/N', "FontSize", 20);
ax = gca;
ax.FontSize = 16;
ylabel('Generalization Error',"FontSize", 20);
legend('show','Location', 'southwest')
text(1, 0.17, "Dimensions = 100", "FontSize", 16)
text(1, 0.15, "Epochs = 100", "FontSize", 16)
text(1, 0.13, "Iterations = 50", "FontSize", 16)