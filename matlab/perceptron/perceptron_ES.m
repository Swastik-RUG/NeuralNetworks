function [weights, embedding_strength] = perceptron_ES(data, labels, c, epochs)
column_count = size(data,2);
row_count = size(data,1);
embedding_strength = zeros(row_count,1);
weights = zeros(column_count,1);
for t=1:epochs
    for row_indx=1:row_count
        % Emu = np.dot(weights, data[row_indx]) * labels[row_indx]
        if (data(row_indx,:) * weights) * labels(row_indx) <= c
            weights = weights + (data(row_indx,:)' * labels(row_indx))/column_count;            
            embedding_strength(row_indx) = embedding_strength(row_indx) + 1;            
        end
    end
       classification = (data * weights) .* labels;
       if all(classification > c)
            break;
       end
end

