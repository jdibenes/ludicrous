
function f = imp_draw_corners(im, ul, um, ur, bl, bm, br)
f = figure();

imshow(im);
hold on
plot([ul.Location(1), um.Location(1), ur.Location(1), bl.Location(1), bm.Location(1), br.Location(1)], [ul.Location(2), um.Location(2), ur.Location(2), bl.Location(2), bm.Location(2), br.Location(2)], 'xr');
end
