function [generalization_error] = kmeans_predict(test, testlabels, centroid_data, labels)
    k = size(centroid_data,1);
    data = test;
    data_size = size(test,1);
    misclassifications = 0;
    for c=1:k
    distances = [];
        for indx=1:data_size
            % Calculate the distance of the point from all the
            % centroids and find the centroid that is closest to
            % the point.
            cur_data_point = data(indx,:);
            dist = pdist2(cur_data_point, centroid_data, 'squaredeuclidean');
            [min_dist, min_indx] = min(dist);
            predicted = labels(min_indx);
            if(testlabels(indx) ~= predicted)
                misclassifications = misclassifications +1;
            end
        end
        generalization_error = misclassifications/data_size;
    end
end