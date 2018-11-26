function [out1 out2] = par_example(a, b, c)

out1 = zeros(length(a), length(b));
out2 = cell(length(a),1);
for i = 1:length(a)
    for j = 1:length(b)
        out1(i,j) = a+b;
        out2{i}(j) = a+b;
    end
end

end