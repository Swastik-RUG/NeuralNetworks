function d = run_adaline(alpha, N, epochs, itr, c, inhomogeneous, learning_rate)
    deviations = zeros(itr, 1);
    for i=1:itr
        P = ceil(alpha*N);
        % A teacher student model but with the
        % weight logic and convergence adopted as per rosenblatts perceptron
        teacher = ones(N, 1);
        [data, labels]= generate_data_with_labels(P, N, teacher, 0);
        if inhomogeneous == 1
            % add clamped input to the data at N+1 dimensions
            data = [data,zeros(size(data, 1), 1)-1];
        end
        
        learning_rate = check_valid_learning_rate(learning_rate, P, N);
        
        [weights]= adaline(data, labels, c, epochs, learning_rate);    
        deviation = acos(dot(weights, teacher) / (norm(weights) * norm(teacher))) / pi;
        deviations(i) = deviation;
    end
    d = mean(deviations);
end

function lr = check_valid_learning_rate(lr, data, N)
    C = [];
    for j=1:size(data,1)
        xi = data(j);
        C =  norm(xi)/N;
    end
    limit = 2/max(C);
    if lr > 0 && lr < limit
        lr = lr;
    else
        fprintf("Invalid learning rate, switching to the max possible learning rate %f \n", limit-0.1);
        lr = limit - 0.1;
    end
end