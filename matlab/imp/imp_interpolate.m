
function x = imp_interpolate(y, y1, y2, x1, x2)
alpha = (y2 - y) / (y2 - y1);
x = alpha * x1 + (1 - alpha) * x2;
end
