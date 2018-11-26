function pathLen = getPathLength(path)

pathLen = 0;
for i = 1:size(path,1) - 1
    pathLen = pathLen + sum((path(i,:) - path(i+1,:)).^2).^0.5;
end

end