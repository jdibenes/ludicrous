
clear all

simulation_reference

%--------------------------------------------------------------------------

name = 'sample_d0_ok';

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

load(['./' name '/imp_z_data.mat']);

stereoParams = data.stereoParams;

K1 = stereoParams.CameraParameters1.IntrinsicMatrix.';
K2 = stereoParams.CameraParameters2.IntrinsicMatrix.';
R2 = stereoParams.RotationOfCamera2;
t2 = -R2*stereoParams.TranslationOfCamera2(:);

im1 = imread(['./' name '/im1.png']); 
im2 = imread(['./' name '/im2.png']);

R = data.R;
t = data.t;

height1 = size(im1, 1);
height2 = size(im2, 1);

points1 = zeros(height1, 10);
points2 = zeros(height2, 10);

[R2_g, t2_g] = pose_transform2(R, t, R2, t2);

for k1 = 1:height1
    pat1 = pat_real(pmodel, K1, R, t, k1);
    points1(k1, :) = [pat_get1D(pat1).', ones(1, 5) * k1];
end

figure();
imshow(im1);
hold on

X1 = points1(:, 1:5);
Y1 = points1(:, 6:10);

plot(X1(:), Y1(:), '.r');

for k2 = 1:height2
    pat2 = pat_real(pmodel, K2, R2_g, t2_g, k2);
    points2(k2, :) = [pat_get1D(pat2).', ones(1, 5) * k2];
end

ul = data.ul;
ur = data.ur;
bl = data.bl;
br = data.br;

plot([ul.Location(1), ur.Location(1), bl.Location(1), br.Location(1)], [ul.Location(2), ur.Location(2), bl.Location(2), br.Location(2)], 'xc', 'MarkerSize', 40, 'LineWidth',3);

drawnow

figure();
imshow(im2);
hold on

X2 = points2(:, 1:5);
Y2 = points2(:, 6:10);

plot(X2(:), Y2(:), '.r');
