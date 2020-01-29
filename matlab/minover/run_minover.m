function [d] = run_minover(alpha, N, epochs, itr, lambda, inhomogeneous)
    deviations = zeros(itr, 1);
    teacher = ones(N, 1);
    parfor i=1:itr
        P = ceil(alpha*N);
        [data, labels]= generate_data_with_labels(P, N, teacher, lambda);
        %if inhomogeneous == 1
            % add clamped input to the data at N+1 dimensions
            %data = [data,zeros(size(data, 1), 1)-1];
        %end
        [student] = minover(data, labels, epochs);    
      
        deviation = acos(dot(student, teacher) / (norm(student) * norm(teacher))) / pi;
        deviations(i) = deviation;
    end
    d = mean(deviations);
end