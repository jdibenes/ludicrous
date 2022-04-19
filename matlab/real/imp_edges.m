
function edges = imp_edges(im, roi, flog, th, points)
x1 = roi(1, 1);
y1 = roi(1, 2);
x2 = roi(2, 1);
y2 = roi(2, 2);

edges = zeros(y2 - y1 + 1, points + 2);

for row = y1:y2
    im_r = im(row, :);
    im_m = imp_median1D(im_r, 1);
    im_d = imp_convolution1D(im_m, flog);
    xstart = round(imp_interpolate(row, y1, y2, x1, x2)); 
    [cols, ok] = imp_edgesdg_fsm(im_d, xstart, th, points);
    edges(row - y1 + 1, :) = [cols, row, ok];
end
end
