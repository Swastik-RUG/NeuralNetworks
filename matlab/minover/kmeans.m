function [centroid, cluster_labels, init_centroid] = kmeans(data, k, max_epochs, kmeans_pp, centroid_data)
% #########################################################################
% data -> The input data to be clustered
% k -> Number of clusters the data needs to be split amongst.
% max_epochs -> Maximum Number of iterations the clustering alogrithm needs to be
% performed before reaching the stability condition, if stability condition
% is reached before max_epochs is reach terminate the clustering.
% kmeans_pp -> Flag to switch to Kmeans++ or Kmeans
%              0 -> Kmeans
%              1 -> Kmeans++
%              any -> Kmeans with custome centroid supplied
% centroid_data -> Contains the explicit centroid postions.
% #########################################################################

    data_size = size(data,1);
    cluster_labels = zeros(data_size,1)-1;
    
    init_centroid = [];
    % Check if centroid positions are explicitly provided.
    if ~exist('centroid_data','var')
        % Check if kmeans is supposed to be used
        if kmeans_pp == 0
            init_centroid = data(randperm(data_size,k),:);
        % Switch to Kmeans++
        else
            init_centroid = [data(randperm(data_size,1),:)];
            for c=1:k-1
            distances = [];
                parfor indx=1:data_size
                    % Calculate the distance of the point from all the
                    % centroids and find the centroid that is closest to
                    % the point.
                    cur_data_point = data(indx,:);
                    dist = pdist2(cur_data_point, init_centroid, 'squaredeuclidean');
                    [min_dist, ~] = min(dist);
                    distances = [distances;min_dist];
                end
                % Get the new centroid based on distribution of the data
                % based on distances.
                new_centroid_indx = randsample(data_size,1, true, distances);
                init_centroid = [init_centroid; data(new_centroid_indx,:)];
            end
        end
    else
        init_centroid = centroid_data;
    end
        
    centroid = init_centroid;
    threshold = 1e-3;
    convergence = threshold + 1;
    cur_epoch = 0;
    % Convergence is a derived value that is based on how significantly the
    % centroids have changed over the previous iteration, if the change is
    % less than the threshold value, perform early termination
    while (convergence > threshold && cur_epoch < max_epochs)      
        for i=1:data_size
            dist = pdist2(data(i,:), centroid, 'euclidean');
            [~, min_indx] = min(dist);
            cluster_labels(i,1) = min_indx;
        end
    
        prev_centroid = centroid;
        % Recompute centroid
        for j=1:k
            cur_centroid_indx = find(cluster_labels==j);
            cur_cluster_points = data(cur_centroid_indx, :);
            new_centroid = mean(cur_cluster_points);
            centroid(j,:) = new_centroid;
        end
        convergence = abs(norm(prev_centroid) - norm(centroid));
        cur_epoch = cur_epoch + 1;        
    end
end