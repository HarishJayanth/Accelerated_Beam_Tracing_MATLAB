function renderSrcAndLst(plotHandle)

axes(plotHandle);

if evalin('base', 'exist(''src'')')
    sPos = evalin('base', 'src.getPosition()');
    if evalin('base', 'exist(''srcPoint'')')
        evalin('base', 'delete(srcPoint)');
    end
    srcPoint = plot3(sPos(1), sPos(2), sPos(3), 'r*', 'LineWidth',10);
    hold on;
    assignin('base', 'srcPoint', srcPoint);
end
if evalin('base', 'exist(''lst'')')
    lPos = evalin('base', 'lst.getPosition()');
    if evalin('base', 'exist(''lstPoint'')')
        evalin('base', 'delete(lstPoint)');
    end
    lstPoint = plot3(lPos(1), lPos(2), lPos(3), 'g+', 'LineWidth',10);
    assignin('base', 'lstPoint', lstPoint);
end
end