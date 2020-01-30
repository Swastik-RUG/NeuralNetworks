function [data, labels] = generate_data_with_labels(P, N, teacher, lambda)
    data = randn(P, N);
    % Generate an array of P size with 0-1 values, values that are less
    % than lambda will be chosen as the noise labels
    noise = cmp_labels(rand(P, 1) < lambda, -1, +1);
    % Multiply noise, if old label = -1 and then a -1 * -1 = flip to +1
    labels = sign(data * teacher).*noise;
end