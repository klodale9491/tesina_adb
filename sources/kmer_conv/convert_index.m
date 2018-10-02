function [value] = convert_index(v,len)
    j = randi([1,len]);
    value = v(j);
end

