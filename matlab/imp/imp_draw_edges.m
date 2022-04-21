
function f = imp_draw_edges(im, edges)
f = figure();
imshow(im);
hold on

for k = 1:size(edges, 1)
    ok = edges(k, end);
    if (ok), marker = 'xg'; else, marker = 'xr'; end
    plot(edges(k, 1:(end - 2)), edges(k, end - 1) * ones(1, size(edges, 2) - 2), marker);
end
end
