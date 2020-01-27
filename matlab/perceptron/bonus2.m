c_values = [0.0];
alphas = [0.75, 1.0, 1.25, 1.50, 2.0, 2.5, 3.0];
% Dimension, change to increase size of P
N = [5, 20, 50, 100, 150, 200];
itr = 50; % Nd - dimensions
epoch = 250; % Nmax
rng(100);
figure
embedding_strength = {};
embedding_strength_state_store = 'state_store/embedding_strength.mat';
if isfile(embedding_strength_state_store) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    embedding_strength = importdata(embedding_strength_state_store, 'embedding_strength');
    for e=1:size(embedding_strength,1)
        epoch = embedding_strength{e};
        success = embedding_strength{e,2};
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
        embedding_strength = [embedding_strength; {epoch, success_for_diff_c}];
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
    save(embedding_strength_state_store, 'embedding_strength')
end