function [data, labels] = generate_data_with_labels(P, N)
    data = randn(P, N);
    labels = cmp_labels(rand(P, 1) < 0.5, -1, 1);
%     for i=1:length(labels)
%         if labels(i) == 0
%             labels(i) = -1;
%         end
%     end
end