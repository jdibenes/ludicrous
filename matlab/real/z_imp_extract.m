
clear all

%--------------------------------------------------------------------------

name = 'sample_d0_ok';
points = 5;
mre = 5;

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

run(['./' name '/imp_z_setup.m']);

load(calibration);

im1 = imp_rgb2gray(imread(['./' name '/im1.png']));
im2 = imp_rgb2gray(imread(['./' name '/im2.png']));

[ul, um, ur, bl, bm, br] = imp_pattern_corners(im1, roiul, roium, roiur, roibl, roibm, roibr);

imp_draw_corners(im1, ul, um, ur, bl, bm, br);
drawnow;

point_select = [select, select + 3];

p2d   = double([ul.Location; um.Location; ur.Location; bl.Location; bm.Location; br.Location]);
p2d   = p2d(point_select, :);
pat3d = pat3d(point_select, :);

[R, t] = imp_p3p(p2d, pat3d, stereoParams.CameraParameters1, mre);

flog = imp_dgfilter(sigma);

edges1 = imp_edges(im1, roi1, flog, th1, points);
edges2 = imp_edges(im2, roi2, flog, th2, points);

imp_draw_edges(im1, edges1);
drawnow;

imp_draw_edges(im2, edges2);
drawnow;

data.stereoParams = stereoParams;

data.edges1 = edges1;
data.edges2 = edges2;

data.R = R;
data.t = t;

data.ul = ul;
data.um = um;
data.ur = ur;
data.bl = bl;
data.bm = bm;
data.br = br;

save(['./' base '/imp_z_data_' name '.mat'], 'data');
