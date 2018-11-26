function IR = getIR(path, mat, fs)

pathLen = zeros(length(path),1);
for i = 1:length(path)
    pathLen(i) = getPathLength(path{i});
end

c = 343;
pathSamp = pathLen * fs / c;

delay = zeros(ceil(max(pathSamp))+3,1);
x = [1; zeros(length(delay) - 1, 1)];
y = zeros(size(delay));
ynm1 = zeros(size(pathSamp));
g = pathLen(1)./pathLen;

p = 1;

for i = 1:length(y)
    delay(p) = x(i);
    
    ynm1 = tapOut(delay, pathSamp, p, ynm1);
    y(i) = sum(ynm1.*g);
    
    p = mod(p, length(delay)) + 1;
end


end