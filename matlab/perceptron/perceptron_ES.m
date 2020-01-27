function embedding_strength = perceptron_ES(data, labels, c, epochs)
column_count = size(data,2);
row_count = size(data,1);
embedding_strength = zeros(column_count,1);
for t=1:epochs
    for row_indx=1:row_count
        % Emu = np.dot(weights, data[row_indx]) * labels[row_indx]
        if (data(row_indx,:) * embedding_strength) * labels(row_indx) <= c
            embedding_strength(row_indx) = embedding_strength(row_indx) + 1;            
        end
    end
       classification = (data * embedding_strength) .* labels;
       if all(classification > c)
            break;
       end
end

