c_values = [0.0];
alphas = [0.75, 1.0, 1.25, 1.50, 2.0, 2.5, 3.0];
% Dimension, change to increase size of P
N = [5, 20, 50, 100, 150, 200];
itr = 50; % Nd - dimensions
epoch = 250; % Nmax
rng(100);
figure
convergence_by_dimension = {};
convergence_by_dimension_state_store = 'state_store/convergence_by_dimension.mat';
if isfile(convergence_by_dimension_state_store) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    convergence_by_dimension = importdata(convergence_by_dimension_state_store, 'convergence_by_dimension');
    for e=1:size(convergence_by_dimension,1)
        epoch = convergence_by_dimension{e};
        success = convergence_by_dimension{e,2};
        subplot(2,3,e)
        py = [];
        for c_res_indx=1:size(success,1)
            plot(alphas, success(c_res_indx, :));
            hold on;
        end
        title(sprintf('Learning Rate Analysis for Dimensions = %d', N(e)));
        xlabel('Alpha = P/N');
        ylabel('Success Rate');
        legend("C = 0.0")
    end
else
    for d=1:length(N)
        subplot(2,3,d)
        dim = N(d);
        success_for_diff_c = zeros(length(c_values), length(alphas));
        for i=1:length(c_values)
            c = c_values(i);
            for j=1:length(alphas)
                alpha = alphas(j);
                success_for_diff_c(i, j) = run_perceptron(alpha, dim, epoch, itr, c, 0);
            end
        end
        convergence_by_dimension = [convergence_by_dimension; {epoch, success_for_diff_c}];
        p3 = [];
        for c_res_indx=1:size(success_for_diff_c,1)
            pl = plot(alphas, success_for_diff_c(c_res_indx, :));
            p3(c_res_indx) = pl;
            hold on;
        end
        title(sprintf('Learning Rate Analysis for Dimension = %d', N(d)));
        xlabel('Alpha = P/N');
        ylabel('Success Rate');
        legends = ["C = 0.0"];
        legend(p3, legends)
    end
    save(convergence_by_dimension_state_store, 'convergence_by_dimension')
end