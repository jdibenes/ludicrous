
function edges = imp_edges_auto(im, flog, th, cr_th)
y1 = 1;
y2 = size(im, 1);

edges = zeros(y2 - y1 + 1, 8 + 2 + 1);

for row = y1:y2
    im_r = im(row, :);
    im_m = imp_median1D(im_r, 1);
    im_d = imp_convolution1D(im_m, flog);
    [cols, ok, cr_min] = imp_edgesdg_fsm_auto(im_d, th, cr_th);
    edges(row - y1 + 1, :) = [cols, cr_min, row, ok];
end
end
