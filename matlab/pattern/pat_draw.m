
function f = pat_draw(pmodel, ext, box_x, box_y, blocksize, iterations, size)
f = figure();

hold on
f.GraphicsSmoothing = 'off';
plot(0, 0, '.w');
xlim(box_x);
ylim(box_y);
set(gca, 'DataAspectRatio', [1 1 1], 'PlotBoxAspectRatio',[1 1 1], 'Position', [0, 0, 1, 1]);
rectangle('Position', [box_x(1), box_y(1), box_x(2) - box_x(1), box_y(2) - box_y(1)], 'FaceColor', 'w', 'EdgeColor', 'w', 'LineWidth', size);

B = zeros(blocksize, 2);
idx = 1;
k = 0;

while (k < iterations)
    p = randpoint(box_x, box_y);
    c = color(pmodel, ext, p);
    if (c == 1), continue; end
    B(idx, :) = p;
    idx = idx + 1;
    if (idx <= blocksize), continue; end
    idx = 1;
    k = k + 1;
    plot(B(:, 1), B(:, 2), '.k', 'MarkerSize', size);
    drawnow
end
end

function p = randpoint(x, y)
p = [x(1) + rand() * (x(2) - x(1)); y(1) + rand() * (y(2) - y(1))];
end

function l = left(p1, p2, p)
l = sign((p2(1) - p1(1)) * (p(2) - p1(2)) - (p2(2) - p1(2)) * (p(1) - p1(1)));
end

function c = color(pmodel, ext, p)
c1 = left(pmodel.p12, pmodel.p11, p) < 0;
c2 = left(pmodel.p22, pmodel.p21, p) < 0;
c3 = left(pmodel.p32, pmodel.p31, p) < 0;
c4 = left(pmodel.p42, pmodel.p41, p) < 0;
c5 = left(pmodel.p52, pmodel.p51, p) < 0;

c = xor(xor(xor(xor(c1, c2), c3), c4), c5);

for k = 1:numel(ext)
cx = left([ext(k), pmodel.p12(2)], [ext(k), pmodel.p11(2)], p) < 0;
c = xor(c, cx);
end
end
