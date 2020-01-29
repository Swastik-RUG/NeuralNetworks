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
lines = ["m-^", "b-o", "r-*", "-v", '--^'];
inhomogenous_c_statestore = 'state_store/inhomogenous_c.mat';
if isfile(inhomogenous_c_statestore) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    inhomogenous_c = importdata(inhomogenous_c_statestore, 'inhomogenous_c');
else
    inhomogenous_c = zeros(length(c_values), length(alphas));
    for i=1:length(c_values)
        c = c_values(i);
        for j=1:length(alphas)
            alpha = alphas(j);
            inhomogenous_c(i, j) = run_perceptron(alpha, N, epochs, itr, c, 1);
        end
    end
    save(inhomogenous_c_statestore, 'inhomogenous_c');
end

figure
p = [];
for c_res_indx=1:size(inhomogenous_c,1)
    pl = plot(alphas, inhomogenous_c(c_res_indx, :));
    p(c_res_indx) = pl;
    hold on;
end
title('Learning Rate Analysis');
xlabel('Alpha = P/N');
ylabel('Success Rate');
legends = ["C = 0.0", "C = 0.5", "C = 1.0", "C = 1.5", "C = 2.0"];
legend(p, legends)

c_values = [0.0, 1.0, 2.0];
alphas = [0.75, 1.0, 1.25, 1.50, 2.0, 2.5, 3.0];
% Dimension, change to increase size of P
N = [100, 200];
itr = 50; % Nd - dimensions
epoch = 500; % Nmax
type = [0,1];
rng(100);

figure('NumberTitle', 'off', 'Name', "Storage success rate homogenous vs inhomogenous",'units','normalized','outerposition',[0 0 1 1])
inhomogenous_vs_homogenous = {};
inhomogenous_vs_homogenous_state_store = 'state_store/inhomogenous_vs_homogenous.mat';
subplot_count = 0;
if isfile(inhomogenous_vs_homogenous_state_store) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    inhomogenous_vs_homogenous = importdata(inhomogenous_vs_homogenous_state_store, 'inhomogenous_vs_homogenous');
    d = 1;
    for e=1:size(inhomogenous_vs_homogenous,1)
        epoch = inhomogenous_vs_homogenous{e};
        success = inhomogenous_vs_homogenous{e,2};
        subplot(2,2,e)
        py = [];
        for c_res_indx=1:size(success,1)
            plot(alphas, success(c_res_indx, :),lines(c_res_indx));
            hold on;
        end
        if mod(e,2) == 1  type_str = "homogenous"; else type_str = "inhomogenous"; end       
        title(sprintf('Storage success rate of %s data for Dimension = %d', type_str, N(d)));
        ax = gca;
        ax.FontSize = 14;
        xlabel('Alpha = P/N');
        ylabel('Success Rate');
        legends = ["C = 0.0", "C = 1.0", "C = 2.0"];
        legend(legends)
        if mod(e,2) == 0 d=d+1; end
    end
else
    subplot_count = 1;
    for d=1:length(N)
        dim = N(d);
        success_for_diff_c = zeros(length(c_values), length(alphas));
        for t=1:length(type)
            % Even execution - inhomogenous, odd execution - homogenous
            exec_type = type(t);
            for i=1:length(c_values)
                c = c_values(i);
                for j=1:length(alphas)
                    alpha = alphas(j);
                    success_for_diff_c(i, j) = run_perceptron(alpha, dim, epoch, itr, c, exec_type);
                end
            end
        inhomogenous_vs_homogenous = [inhomogenous_vs_homogenous; {epoch, success_for_diff_c}];
        
        p3 = [];
        
        subplot(2,2,subplot_count)
        for c_res_indx=1:size(success_for_diff_c,1)
            pl = plot(alphas, success_for_diff_c(c_res_indx, :),lines(c_res_indx));
            p3(c_res_indx) = pl;
            hold on;
        end
        subplot_count = subplot_count+1;
        type_str = "";
         if mod(t,2) == 1  type_str = "homogenous"; else type_str = "inhomogenous"; end
        title(sprintf('Storage success rate of %s data for Dimension = %d', type_str, N(d)));
        ax = gca;
        ax.FontSize = 14;
        xlabel('Alpha = P/N');
        ylabel('Success Rate');
        legends = ["C = 0.0", "C = 1.0", "C = 2.0"];
        legend(p3, legends)
        end
    end
    save(inhomogenous_vs_homogenous_state_store, 'inhomogenous_vs_homogenous')
end
