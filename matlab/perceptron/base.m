clc;
clear;
c_values = [0.0];
alphas = [0.75, 1.0, 1.25, 1.50, 2.0, 2.5, 3.0];
% Dimension, change to increase size of P
N = 20;
itr = 50; % Nd - dimensions
epochs = 100; % Nmax
rng(100);
USE_STATE_STORE = 1;

base_statestore = 'state_store/base.mat';
if isfile(base_statestore) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    success_for_diff_c = importdata(base_statestore, 'success_for_diff_c');
else
    success_for_diff_c = zeros(length(c_values), length(alphas));
    for i=1:length(c_values)
        c = c_values(i);
        for j=1:length(alphas)
            alpha = alphas(j);
            %[success, results] = run_perceptron(alpha, N, epochs, itr, c);
            success_for_diff_c(i, j) = run_perceptron(alpha, N, epochs, itr, c, 0);
        end
    end
    save(base_statestore, 'success_for_diff_c');
end

figure
p = [];
for c_res_indx=1:size(success_for_diff_c,1)
    pl = plot(alphas, success_for_diff_c(c_res_indx, :));
    p(c_res_indx) = pl;
    hold on;
end
title('Learning Rate Analysis');
xlabel('Alpha = P/N');
ylabel('Success Rate');
legends = ["C = 0.0"];
legend(p, legends)