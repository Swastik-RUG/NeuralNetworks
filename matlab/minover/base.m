clc;
clear;
c_values = [0.0];
alphas = 0.1:0.1:5;
% Dimension, change to increase size of P
N = 200;
itr = 100; % Nd - dimensions
epochs = 200; % Nmax
rng(100);
USE_STATE_STORE = 1;

base_statestore = 'state_store/base.mat';
if isfile(base_statestore) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    deviations_base = importdata(base_statestore, 'deviations_base');
else
    deviations_base = zeros(1, length(alphas));
        for j=1:length(alphas)
            alpha = alphas(j);
            %[success, results] = run_perceptron(alpha, N, epochs, itr, c);
            deviations_base(1, j) = run_minover(alpha, N, epochs, itr, 0.0, 0);
        end
    save(base_statestore, 'deviations_base');
end

figure
p = [];
for indx=1:size(deviations_base,1)
    pl = plot(alphas, deviations_base, 'b-^');
    p(indx) = pl;
    hold on;
end
title('Minover Generalization Error Analysis');
ax = gca;
ax.FontSize = 16;
xlabel('Alpha = P/N', "FontSize", 20);
ylabel('Generalization Error',"FontSize", 20);
legends = ["Error"];
legend(p, legends)