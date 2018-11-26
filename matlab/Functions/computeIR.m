function ir = computeIR(p, fs)

numPaths = p.numPaths();

order = zeros(numPaths,1);
path = cell(numPaths,1);
mat = cell(numPaths,1);

for i=1:numPaths
    [order(i) path{i} mat{i}] = p.getPath(i);
end

pathLen = zeros(length(path),1);
for i = 1:length(path)
    pathLen(i) = getPathLength(path{i});
end

c = 343;    % speed of sound = 343 m/s
pathSamp = (pathLen * fs / c) + 1;

delay = zeros(ceil(max(pathSamp))+3,1);
x = [1; zeros(length(delay) - 1, 1)];
ir = zeros(size(delay));
ynm1 = zeros(size(pathSamp));
if pathLen(1)~=0
    g = min(pathLen)./pathLen;
else
    g = min(pathLen(2:end))./pathLen;
    g(1) = 1;
end

% y = zeros(ceil(max(pathSamp)),1);
% y(ceil(pathSamp)) = g.*sig_interp(1,1-mod(pathSamp,1));
% f1 = figure;
% figure(f1);
% plot(y);

load('filtImp.mat');
m = evalin('base', 'matFile');

path_refl_gain = ones(numPaths, 10);
for i = 2:numPaths
    for j = 1:length(mat{i})
        matProps = m.find(char(mat{i}(j,:)));
        path_refl_gain(i,:) = path_refl_gain(i,:).*(1-matProps.Absorption);
    end
end

impLen = size(b,2);
ir = zeros(ceil(max(pathSamp)) + impLen + 1,1);
for i = 1:numPaths
    sampBegin = ceil(pathSamp(i));
    pathImp = g(i)*path_refl_gain(i,:) * b;
    ir(sampBegin:sampBegin + impLen - 1) = ir(sampBegin:sampBegin + impLen - 1) + ...
       sig_interp(pathImp', 1 - mod(pathSamp(i),1));
end

end