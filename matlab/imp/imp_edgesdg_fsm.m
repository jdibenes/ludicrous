
function [edges, ok] = imp_edgesdg_fsm(line, roistart, th, points)
width = numel(line);
line = abs(line);
line(line < th) = 0;

edges = zeros(1, points);
state = 0;
index = 0;

for col = roistart:(width - 1)
    data = line(col);
    
    switch (state)
    case 0, if (data >  0),     x1 = col;          prev = data;       state = 1; end
    case 1, if (data >= prev),  x1 = col;          prev = data;
            elseif (data == 0), index = index + 1; edges(index) = x1; state = 0; if (index >= points), break; end
            end
    end
end

ok = index >= points;

for k = 1:index
    x2 = edges(k);
    y1 = line(x2 - 1);
    y2 = line(x2);
    y3 = line(x2 + 1);
    edges(k) = x2 + 0.5 * ((y1 - y3) / (y1 - 2*y2 + y3));
end
end
