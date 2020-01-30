% Ref: https://stackoverflow.com/questions/14612196/is-there-a-matlab-conditional-if-operator-that-can-be-placed-inline-like-vbas-i#answer-14613083
function result = cmp_labels(condition, a, b)
    if isscalar(condition)
       if condition
           result = a;
       else
           result = b;
       end
    else
        result = (condition) .* a + (~condition) .* b;
    end
end
