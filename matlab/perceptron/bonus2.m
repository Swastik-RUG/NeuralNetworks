c_values = [0.0];
alphas = [3.0];
% Dimension, change to increase size of P
N = [5, 20, 50, 100, 150, 200];
itr = 50; % Nd - dimensions
epoch = 250; % Nmax
rng(100);
USE_STATE_STORE = 1;
figure('NumberTitle', 'off', 'Name', "Embedding strength by dimension",'units','normalized','outerposition',[0 0 1 1])
embedding_strength = [];
embedding_strength_counts = [];
embedding_strength_state_store = 'state_store/embedding_strength.mat';
if isfile(embedding_strength_state_store) && USE_STATE_STORE == 1
    fprintf("Skipping execution - Using state store results \n")
    embedding_strength = importdata(embedding_strength_state_store, 'embedding_strength').embedding_strength;
    embedding_strength_counts = importdata(embedding_strength_state_store, 'embedding_strength_counts').embedding_strength_counts;
    for e=1:size(embedding_strength,1)
        subplot(2,3,e)
        data = cell2mat(embedding_strength_counts(e));
        r = cell2mat(embedding_strength(e));
        x = round(size(data,2)/5);
        histogram(r, x)
        hold on;
        title(sprintf('Embedding strength for Dimension = %d', N(e)));
        xlabel('Embedding strength');
        ylabel('Embedding strengths update count');
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
                [success_for_diff_c(i, j), ~, es] = run_perceptron_es(alpha, dim, epoch, itr, c, 0);          
            end
        end
        r = [];
        data = es';
        for i=1:length(data)
            v = data(i);
            for j=1:v
                r = [r; i];
            end
        end
        embedding_strength = [embedding_strength; {r}];
        embedding_strength_counts = [embedding_strength_counts, {es'}];
        x = round(size(data,2)/5);
        histogram(r, x)
        hold on;
        title(sprintf('Embedding strength for Dimension = %d', N(d)));
        xlabel('Embedding strength');
        ylabel('Embedding strengths update count');
    end
    save(embedding_strength_state_store, 'embedding_strength', 'embedding_strength_counts')
end