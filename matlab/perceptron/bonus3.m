clc;
clear;
c_values = [0.0, 0.5, 1.0, 1.5, 2.0];
alphas = [0.75, 1.0, 1.25, 1.50, 2.0, 2.5, 3.0];
% Dimension, change to increase size of P
N = 20;
itr = 50; % Nd - dimensions
epochs = 100; % Nmax
rng(100);
USE_STATE_STORE = 1;
lines = ["-^", "-o", "-*", "-v", '--^'];

diff_LR_statestore = 'state_store/diff_learning_rate.mat';
if isfile(diff_LR_statestore) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    success_for_diff_c = importdata(diff_LR_statestore, 'success_for_diff_c');
else
    success_for_diff_c = zeros(length(c_values), length(alphas));
    for i=1:length(c_values)
        c = c_values(i);
        for j=1:length(alphas)
            alpha = alphas(j);
            success_for_diff_c(i, j) = run_perceptron(alpha, N, epochs, itr, c, 0);
        end
    end
    save(diff_LR_statestore, 'success_for_diff_c');
end

figure('NumberTitle', 'off', 'Name', "Storage success rate for different thresholds(c)",'units','normalized','outerposition',[0 0 1 1])

p = [];
for c_res_indx=1:size(success_for_diff_c,1)
    pl = plot(alphas, success_for_diff_c(c_res_indx, :), lines(c_res_indx));
    p(c_res_indx) = pl;
    hold on;
end
title('Storage success rate for different thresholds(c)');
ax = gca;
ax.FontSize = 18;
xlabel('Alpha = P/N');
ylabel('Success Rate');
legends = ["C = 0.0", "C = 0.5", "C = 1.0", "C = 1.5", "C = 2.0"];
legend(p, legends)
annotation('textbox',...
    [0.669, 0.65, 0.1, 0.1],...
    'String',{'alphas = [0.75, 1.0, 1.25, 1.50, 2.0, 2.5, 3.0]','Dimensions = 20', 'Nmax = 50', 'Epochs(tmax) = 100'},...
    'FontSize',16,...
    'FontName','Arial',...
    'LineWidth',1);

% C is 0.0, 1.0, 2.0. The iterations are increases to see if there is a
% difference

c_values = [0.0, 1.0, 2.0];
alphas = [0.75, 1.0, 1.25, 1.50, 2.0, 2.5, 3.0];
% Dimension, change to increase size of P
N = 20;
itr = 50; % Nd - dimensions
epochs = [100, 250, 500, 1000]; % Nmax
rng(100);

figure('NumberTitle', 'off', 'Name', "Storage success rate for different Epochs(tmax)",'units','normalized','outerposition',[0 0 1 1])
learning_rate_by_epochs = {};
learning_rate_by_epochs_state_store = 'state_store/learning_rate_by_epochs.mat';
if isfile(learning_rate_by_epochs_state_store) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    learning_rate_by_epochs = importdata(learning_rate_by_epochs_state_store, 'learning_rate_by_epochs');
    for e=1:size(learning_rate_by_epochs,1)
        epoch = learning_rate_by_epochs{e};
        success = learning_rate_by_epochs{e,2};
        subplot(2,2,e)
        py = [];
        for c_res_indx=1:size(success,1)
            plot(alphas, success(c_res_indx, :),lines(c_res_indx));
            hold on;
        end
        title(sprintf('Storage success rate for Epochs(tmax) = %d', epoch));
        ax = gca;
        ax.FontSize = 16;
        xlabel('Alpha = P/N');
        ylabel('Success Rate');
        legend(cellstr(num2str(epochs', 'epochs=%-d')))
    end
else
    for ep=1:length(epochs)
        subplot(2,2,ep)
        epoch = epochs(ep);
        success_for_diff_c = zeros(length(c_values), length(alphas));
        for i=1:length(c_values)
            c = c_values(i);
            for j=1:length(alphas)
                alpha = alphas(j);
                success_for_diff_c(i, j) = run_perceptron(alpha, N, epoch, itr, c, 0);
            end
        end
        learning_rate_by_epochs = [learning_rate_by_epochs; {epoch, success_for_diff_c}];
        p2 = [];
        for c_res_indx=1:size(success_for_diff_c,1)
            pl = plot(alphas, success_for_diff_c(c_res_indx, :),lines(c_res_indx));
            p2(c_res_indx) = pl;
            hold on;
        end
        title(sprintf('Storage success rate for Epochs(tmax) = %d', epochs(ep)));
        ax = gca;
        ax.FontSize = 16;
        xlabel('Alpha = P/N');
        ylabel('Success Rate');
        legends = ["C = 0.0", "C = 1.0", "C = 2.0"];
        legend(p2, legends)
    end
    save(learning_rate_by_epochs_state_store, 'learning_rate_by_epochs')
end

% From the above we see that Higher epoch leads to better accuracy.
% Fix epoch to 1000 and increase the dimension of the data to see the
% effect of learning rates over it

c_values = [0.0, 1.0, 2.0];
alphas = [0.75, 1.0, 1.25, 1.50, 2.0, 2.5, 3.0];
% Dimension, change to increase size of P
N = [50, 100, 150, 200];
itr = 50; % Nd - dimensions
epoch = 1000; % Nmax
rng(100);
figure('NumberTitle', 'off', 'Name', "Storage success rate for different Dimensions",'units','normalized','outerposition',[0 0 1 1])
learning_rate_by_dimensions = {};
learning_rate_by_dimensions_state_store = 'state_store/learning_rate_by_dimensions.mat';
if isfile(learning_rate_by_dimensions_state_store) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    learning_rate_by_dimensions = importdata(learning_rate_by_dimensions_state_store, 'learning_rate_by_epochs');
    for e=1:size(learning_rate_by_dimensions,1)
        epoch = learning_rate_by_dimensions{e};
        success = learning_rate_by_dimensions{e,2};
        subplot(2,2,e)
        py = [];
        for c_res_indx=1:size(success,1)
            plot(alphas, success(c_res_indx, :),lines(c_res_indx));
            hold on;
        end
        title(sprintf('Storage success rate for Dimensions = %d', N(e)));
        ax = gca;
        ax.FontSize = 16;
        xlabel('Alpha = P/N');
        ylabel('Success Rate');
        legends = ["C = 0.0", "C = 1.0", "C = 2.0"];
        legend(legends)
    end
else
    for d=1:length(N)
        subplot(2,2,d)
        dim = N(d);
        success_for_diff_c = zeros(length(c_values), length(alphas));
        for i=1:length(c_values)
            c = c_values(i);
            for j=1:length(alphas)
                alpha = alphas(j);
                success_for_diff_c(i, j) = run_perceptron(alpha, dim, epoch, itr, c, 0);
            end
        end
        learning_rate_by_dimensions = [learning_rate_by_dimensions; {epoch, success_for_diff_c}];
        p3 = [];
        for c_res_indx=1:size(success_for_diff_c,1)
            pl = plot(alphas, success_for_diff_c(c_res_indx, :),lines(c_res_indx));
            p3(c_res_indx) = pl;
            hold on;
        end
        title(sprintf('Storage success rate for Dimension = %d', N(d)));
        ax = gca;
        ax.FontSize = 16;
        xlabel('Alpha = P/N');
        ylabel('Success Rate');
        legends = ["C = 0.0", "C = 1.0", "C = 2.0"];
        legend(p3, legends)
    end
    save(learning_rate_by_dimensions_state_store, 'learning_rate_by_dimensions')
end

