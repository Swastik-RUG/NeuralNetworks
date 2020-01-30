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

figure('NumberTitle', 'off', 'Name', "STORAGE SUCCESS RATE",'units','normalized','outerposition',[0 0 1 1])
p = [];
for c_res_indx=1:size(success_for_diff_c,1)
    pl = plot(alphas, success_for_diff_c(c_res_indx, :), 'r-o');
    p(c_res_indx) = pl;
    hold on;
end
title('STORAGE SUCCESS RATE');
ax = gca;
ax.FontSize = 16;
xlabel('Alpha = P/N', "FontSize", 20);
ylabel('Success Rate', "FontSize", 20);
legends = ["Error"];
legend(p, legends)
annotation('textbox',...
    [0.667, 0.77, 0.1, 0.1],...
    'String',{'alphas = [0.75, 1.0, 1.25, 1.50, 2.0, 2.5, 3.0]','Dimensions = 20', 'Nmax = 50', 'Epochs(tmax) = 100'},...
    'FontSize',16,...
    'FontName','Arial',...
    'LineWidth',1);
