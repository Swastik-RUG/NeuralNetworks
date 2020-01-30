function [student] = minover(data, labels, epochs)
    column_count = size(data,2);
    row_count = size(data,1);
    student = zeros(column_count,1);
    threshold = 1e-3;
    for t=1:epochs*row_count
            % Used later to check convergance (method commonly used in
            % kmeans to find convergance)
            prev_student_weights = student;
            % Kappa Mu with min distance from decision boundary
            % Ignoring |student| at denominator as it doesnt affect the
            % results (scalable factor)
           [~, indx] = min((data * student) .* labels);
           student = student + (data(indx,:)' * labels(indx))/column_count;
           
           if all(norm(prev_student_weights - student) / norm(student) < threshold)
             break
           end
    end
end