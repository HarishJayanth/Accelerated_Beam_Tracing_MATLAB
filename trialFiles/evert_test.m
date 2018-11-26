% evert test
clear;

s = source();
l = listener();
s.setPosition([1.5 1.5 1.5]);
l.setPosition([4 4 4]);
m = materialFile();
m.readFile('E:\Music Tech\MUMT 618\Project\AcceleratedBeamTracing_Matlab\evert\data\materials.dat');

% roomFile = 'E:\Music Tech\MUMT 618\Project\AcceleratedBeamTracing_Matlab\evert\data\sigyn.room';
roomFile_path = 'exRoom.room';
rm = Room();
rm.import(roomFile_path,m);
roomFig = renderRoom(roomFile_path);

p = PathSolution(rm, s, l, 10);
p.solve;
p.update;
numPaths = p.numPaths;

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

fs = 48000;
c = 343;
pathSamp = pathLen * fs / c;

delay = zeros(ceil(max(pathSamp))+3,1);
x = [1; zeros(length(delay) - 1, 1)];
y = zeros(size(delay));
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
% filtStates = cell(numPaths,1);
% p = 1;

path_refl_gain = ones(numPaths, 10);
for i = 2:numPaths
    for j = 1:length(mat{i})
        matProps = m.find(char(mat{i}(j,:)));
        path_refl_gain(i,:) = path_refl_gain(i,:).*(1-matProps.Absorption);
    end
end

impLen = size(b,2);
y = zeros(ceil(max(pathSamp)) + impLen + 1,1);
for i = 1:numPaths
    sampBegin = ceil(pathSamp(i));
    pathImp = g(i)*path_refl_gain(i,:) * b;
%     plot(pathImp);
    y(sampBegin:sampBegin + impLen - 1) = y(sampBegin:sampBegin + impLen - 1) + ...
       sig_interp(pathImp', 1 - mod(pathSamp(i),1));
end
f = figure;
figure(f);
plot(y);
% 
% yout = zeros(numPaths, 1);
% tic;
% for i = 1:length(y)
%     delay(p) = x(i);
%     
%     ynm1 = tapOut(delay, pathSamp, p, ynm1);
% %     tic;
%     for j = 1:numPaths
%         [yout(j), filtStates{j}] = reflFilter(ynm1(j), path_refl_gain(j,:), filtStates{j}, filtCoeffs);
%     end
% %     toc;
%     
%     y(i) = sum(yout.*g);
%     
%     p = mod(p, length(delay)) + 1;
% end
% toc;
figure(roomFig);
for i = 1:length(path)
    plot3(path{i}(:,1),path{i}(:,2),path{i}(:,3),'b');
    hold on;
end
sPos = s.getPosition();
lPos = l.getPosition();
plot3(sPos(1), sPos(2), sPos(3), 'r*', 'LineWidth',10);
plot3(lPos(1), lPos(2), lPos(3), 'bo', 'LineWidth',10);
hold off;
