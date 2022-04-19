
function [ul, um, ur, bl, bm, br] = imp_pattern_corners(im, boxul, boxum, boxur, boxbl, boxbm, boxbr)
ul = imp_corners(im, boxul);
um = imp_corners(im, boxum);
ur = imp_corners(im, boxur);
bl = imp_corners(im, boxbl);
bm = imp_corners(im, boxbm);
br = imp_corners(im, boxbr);
end
