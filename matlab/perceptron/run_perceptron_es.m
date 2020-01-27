function [success, results] = run_perceptron_es(alpha, N, epochs, itr, c, inhomogeneous)
    results = zeros(itr, 1);
    for i=1:itr
        P = ceil(alpha*N);
        [data, labels]= generate_data_with_labels(P, N);
        if inhomogeneous == 1
            % add clamped input to the data at N+1 dimensions
            data = [data,zeros(size(data, 1), 1)-1];
        end
        weights = perceptron_ES(data, labels, c, epochs);    
        success = all(cmp_labels(data * weights <= c, -1, 1) == labels);
        results(i) = success;
    end
    success=sum(results)/length(results);
end