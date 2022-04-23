
clear all

%--------------------------------------------------------------------------

name   = 'sample_d12_ok';
points = 5;
mre    = 5;
factor = 4;

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

run(['./' name '/imp_z_setup.m']);

load(calibration);

im1 = imp_rgb2gray(imread(['./' name '/im1.png']));
im2 = imp_rgb2gray(imread(['./' name '/im2.png']));

im1 = imresize(im1, 1/factor);
im2 = imresize(im2, 1/factor);

flog = imp_dgfilter(sigma);

edges1 = imp_edges(im1, round(roi1 / factor), flog, th1, points);
edges2 = imp_edges(im2, round(roi2 / factor), flog, th2, points);

imp_draw_edges(im1, edges1);
drawnow;

imp_draw_edges(im2, edges2);
drawnow;

dataf.stereoParams = stereoParams;

dataf.edges1 = edges1;
dataf.edges2 = edges2;

dataf.factor = factor;

save(['./' name '/imp_z_data_' num2str(factor) '.mat'], 'dataf');
