function renderPaths(p, plotHandle)

if nargin == 1
    plotHandle = figure();
    figure(plotHandle);
else
    axes(plotHandle);
end

numPaths = p.numPaths();
path = cell(numPaths,1);

for i=1:numPaths
    [~, path{i}, ~] = p.getPath(i);
end

if evalin('base', 'exist(''pathLines'')')
    for i = 1:evalin('base', 'length(pathLines)')
        evalin('base', ['delete(pathLines{' num2str(i) '})']);
    end
end

pathLines = cell(numPaths,1);
for i = 1:length(path)
    pathLines{i} = plot3(path{i}(:,1),path{i}(:,2),path{i}(:,3),'b');
    hold on;
end

assignin('base', 'pathLines', pathLines);
renderSrcAndLst(plotHandle);

end
