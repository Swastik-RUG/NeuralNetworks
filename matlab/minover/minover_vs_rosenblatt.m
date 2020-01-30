clc;
clear;
c_values = [0.0];
alphas = 0.1:0.1:5;
% Dimension, change to increase size of P
N = 100;
itr = 50; % Nd - dimensions
epochs = 100; % Nmax
rng(100);
USE_STATE_STORE = 1;

minover_vs_rosenblatt_statestore = 'state_store/minover_vs_rosenblatt.mat';
if isfile(minover_vs_rosenblatt_statestore) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    deviations_base_minover = importdata(minover_vs_rosenblatt_statestore, 'deviations_base_minover').deviations_base_minover;
    deviations_base_rosenblatt = importdata(minover_vs_rosenblatt_statestore, 'deviations_base_rosenblatt').deviations_base_rosenblatt;
else
    deviations_base_minover = zeros(1, length(alphas));
        for j=1:length(alphas)
            alpha = alphas(j);
            tic;
            deviations_base_minover(1, j) = run_minover(alpha, N, epochs, itr, 0.0, 0);
            toc;
            tic;
            deviations_base_rosenblatt(1, j)= run_perceptron(alpha, N, epochs, itr, 0.0, 0.0, 0);
            toc;
        end
    save(minover_vs_rosenblatt_statestore, 'deviations_base_minover', 'deviations_base_rosenblatt');
end

figure('NumberTitle', 'off', 'Name', "Minover vs Rosenblatts [Generalization Error]",'units','normalized','outerposition',[0 0 1 1])
p = [];
for indx=1:size(deviations_base_minover,1)
    pl = plot(alphas, deviations_base_minover, 'b-^');
    hold on;
    p2 = plot(alphas, deviations_base_rosenblatt, 'r-o');
    p = [pl, p2];
    hold on;
end
title('Minover vs Rosenblatts [Generalization Error]');
ax = gca;
ax.FontSize = 16;
xlabel('Alpha = P/N', "FontSize", 20);
ylabel('Generalization Error',"FontSize", 20);
legends = ["Minover", "Rosenblatt"];
legend(p, legends)
annotation('textbox',...
    [0.76, 0.75, 0.1, 0.1],...
    'String',{'alphas = [0.1,0.2,0.3....5]','Dimensions = 100', 'Nmax = 50', 'Epochs(tmax) = 100'},...
    'FontSize',16,...
    'FontName','Arial',...
    'LineWidth',0.5);