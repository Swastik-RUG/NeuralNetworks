clc;
clear;
learning_rates = [0.1:0.1:0.3];
alphas = 0.1:0.1:5;
% Dimension, change to increase size of P
N = 100; % Nd - dimensions
itr = 50; 
epochs = 100; % Nmax
rng(100);
USE_STATE_STORE = 1;

adaline_statestore = 'state_store/adaline.mat';
if isfile(adaline_statestore) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    deviations_adaline = importdata(adaline_statestore, 'deviations_adaline');
else
     x = [];
    deviations_adaline = zeros(length(learning_rates), length(alphas));
    for i =1:length(learning_rates)
        lr = learning_rates(i);
        for j=1:length(alphas)
            alpha = alphas(j);
            tic;
            deviations_adaline(i, j) = run_adaline(alpha, N, epochs, itr, 0.0, 0, lr);
            x  = [x, toc];
        end
    end
    mean(x);
    save(adaline_statestore, 'deviations_adaline');
end

figure('NumberTitle', 'off', 'Name', "Adaline algorithm",'units','normalized','outerposition',[0 0 1 1])
lines = ["b-*", "m-o", "r-^", "-v", '--^'];
for indx=1:size(deviations_adaline,1)
    pl = plot(alphas, deviations_adaline(indx, :), lines(indx), 'DisplayName', sprintf("Learning Rate = %.1f",learning_rates(indx)));
    hold on;
end
title('Adaline Generalization Error Analysis');
ax = gca;
ax.FontSize = 16;
xlabel('Alpha = P/N', "FontSize", 20);
ylabel('Generalization Error',"FontSize", 20);
legend("show")
annotation('textbox',...
    [0.76, 0.72, 0.1, 0.1],...
    'String',{'alphas = [0.1,0.2,0.3....5]','Dimensions = 100', 'Nmax = 50', 'Epochs(tmax) = 100'},...
    'FontSize',16,...
    'FontName','Arial',...
    'LineWidth',0.5);