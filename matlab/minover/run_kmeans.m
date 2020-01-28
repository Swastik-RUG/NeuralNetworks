function [d] = run_kmeans(alpha, N, epochs, itr, c, lambda, inhomogeneous)
    deviations = zeros(itr, 1);
    epochs_at_convergences = zeros(itr, 1);
    for i=1:itr
        centroid = {};
        P = ceil(alpha*N);
        % A teacher student model but with the
        % weight logic and convergence adopted as per rosenblatts perceptron
        teacher = ones(N, 1);
        [data, labels]= generate_data_with_labels(P, N, teacher, lambda);
        if inhomogeneous == 1
            % add clamped input to the data at N+1 dimensions
            data = [data,zeros(size(data, 1), 1)-1];
        end
        [train, trainlabels, test, testlabels] = split_data(data, labels, 0.3);
        c1 = data(find(labels==-1),:);
        c2 = data(find(labels==1),:);
        if size(c1,1) > 1 c1 = mean(c1); end
        if size(c2,1) > 1 c2 = mean(c2); end
        centroid = [c1; c2];
        cluster_labels = [-1, 1];
        [deviation] = kmeans_predict(test,testlabels, centroid, cluster_labels);
        % epochs_at_convergences(i) = min_req_epochs;
        % deviation = acos(dot(weights, teacher) / (norm(weights) * norm(teacher))) / pi;
        deviations(i) = deviation;
    end
    d = mean(deviations);
    %e = round(mean(epochs_at_convergences));
end

function [dataTrain, labelsTrain, dataTest, labelsTest] = split_data(data, labels, p)
    % Cross varidation (train: 70%, test: 30%)
    cv = cvpartition(size(data,1),'HoldOut',p);
    idx = cv.test;
    % Separate to training and test data
    dataTrain = data(~idx,:);
    dataTest  = data(idx,:);
    labelsTrain = labels(~idx,:);
    labelsTest = labels(idx,:);
end