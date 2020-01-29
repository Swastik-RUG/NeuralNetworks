function d = run_perceptron(alpha, N, epochs, itr, c, lambda, inhomogeneous)
    deviations = zeros(itr, 1);
    for i=1:itr
        P = ceil(alpha*N);
        % A teacher student model but with the
        % weight logic and convergence adopted as per rosenblatts perceptron
        teacher = ones(N, 1);
        [data, labels]= generate_data_with_labels(P, N, teacher, lambda);
        if inhomogeneous == 1
            % add clamped input to the data at N+1 dimensions
            data = [data,zeros(size(data, 1), 1)-1];
        end
        [weights]= perceptron(data, labels, c, epochs);    
        deviation = acos(dot(weights, teacher) / (norm(weights) * norm(teacher))) / pi;
        deviations(i) = deviation;
    end
    d = mean(deviations);
end