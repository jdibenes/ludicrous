
clear all

simulation_reference

%%

%--------------------------------------------------------------------------

name  = 'auto_1';
mre   = 5;
dx_th = 2;

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

%% 

run(['./' name '/imp_z_setup.m']);

load(calibration);

old_pattern_scale = 1.0584799;

im1 = imp_rgb2gray(imread(['./' name '/I0F0.png']));
im2 = imp_rgb2gray(imread(['./' name '/I1F0.png']));

[ul, um, ur, bl, bm, br] = imp_pattern_corners(im1, roiul, roium, roiur, roibl, roibm, roibr);
%imp_draw_corners(im1, ul, um, ur, bl, bm, br);
%drawnow;

p2d = double([ul.Location; um.Location; ur.Location; bl.Location; bm.Location; br.Location]);
[R, t] = imp_p3p(p2d, pat3d, stereoParams.CameraParameters1, mre);

K1 = stereoParams.CameraParameters1.IntrinsicMatrix.';
K2 = stereoParams.CameraParameters2.IntrinsicMatrix.';
R2 = stereoParams.RotationOfCamera2;
t2 = -R2*stereoParams.TranslationOfCamera2(:) * old_pattern_scale;

[R2_g, t2_g] = pose_transform2(R, t, R2, t2);
[R_w,  t_w]  = pose_transform1(R,    t);
[R2_w, t2_w] = pose_transform1(R2_g, t2_g);

patU.A = pat3d(1, :).';
patU.B = [0;0;0];
patU.C = [0;0;0];
patU.D = [0;0;0];
patU.E = pat3d(3, :).';

patB.A = pat3d(4, :).';
patB.B = [0;0;0];
patB.C = [0;0;0];
patB.D = [0;0;0];
patB.E = pat3d(6, :).';

pat1U = pat_reproject(K1, R_w,  t_w,  patU);
pat2U = pat_reproject(K2, R2_w, t2_w, patU);
pat1B = pat_reproject(K1, R_w,  t_w,  patB);
pat2B = pat_reproject(K2, R2_w, t2_w, patB);

vU1 =  ceil(max([pat1U.qa(2)/pat1U.qa(3), pat1U.qe(2)/pat1U.qe(3)]));
vB1 = floor(min([pat1B.qa(2)/pat1B.qa(3), pat1B.qe(2)/pat1B.qe(3)]));

vU2 =  ceil(max([pat2U.qa(2)/pat2U.qa(3), pat2U.qe(2)/pat2U.qe(3)]));
vB2 = floor(min([pat2B.qa(2)/pat2B.qa(3), pat2B.qe(2)/pat2B.qe(3)]));

flog = imp_dgfilter(sigma);

edges1 = imp_edges_auto(im1, flog, th1, cr_th1);
edges2 = imp_edges_auto(im2, flog, th2, cr_th2);

%%

FP1 = 0;
EP1 = 0;
FN1 = 0;
TN1 = 0;
TP1 = 0;

FP2 = 0;
EP2 = 0;
FN2 = 0;
TN2 = 0;
TP2 = 0;

for k=1:2160
if (~edges1(k, end))
    if (k < vU1 || k > vB1), TN1 = TN1 + 1; else, FN1 = FN1 + 1; end
else
    if (k >= vU1 && k <= vB1)
        pat1 = pat_real(pmodel, K1, R, t, k);
        err1 = min(abs([pat1.a - edges1(k, 1), pat1.b - edges1(k, 2), pat1.c - edges1(k, 3), pat1.d - edges1(k, 4), pat1.e - edges1(k, 5)]));
        if (err1 < dx_th), TP1 = TP1 + 1; else, EP1 = EP1 + 1; end
    else
        FP1 = FP1 + 1;
    end
end
end

for k=1:2160
if (~edges2(k, end))
    if (k < vU2 || k > vB2), TN2 = TN2 + 1; else, FN2 = FN2 + 1; end
else
    if (k >= vU2 && k <= vB2)
        pat2 = pat_real(pmodel, K2, R2_g, t2_g, k);
        err2 = min(abs([pat2.a - edges2(k, 1), pat2.b - edges2(k, 2), pat2.c - edges2(k, 3), pat2.d - edges2(k, 4), pat2.e - edges2(k, 5)]));
        if (err2 < dx_th), TP2 = TP2 + 1; else, EP2 = EP2 + 1; end
    else
        FP2 = FP2 + 1;
    end
end
end

imp_draw_edges(im1, edges1(edges1(:, end) == 1, :));
for k=1:2160, if (~edges1(k, end)), plot([1, 3840], [k, k], ':r'); end; end
drawnow;

imp_draw_edges(im2, edges2(edges2(:, end) == 1, :));
for k=1:2160, if (~edges2(k, end)), plot([1, 3840], [k, k], ':r'); end; end
drawnow;

data.TN1 = TN1;
data.FN1 = FN1;
data.TP1 = TP1;
data.EP1 = EP1;
data.FP1 = FP1;

data.TN2 = TN2;
data.FN2 = FN2;
data.TP2 = TP2;
data.EP2 = EP2;
data.FP2 = FP2;

disp(100 * ((TP1 + TN1) / 2160));
disp(100 * ((TP2 + TN2) / 2160));

save(['./' name '/undistorted/imp_z_data.mat'], 'data');
