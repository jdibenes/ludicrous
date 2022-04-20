
clear all

simulation_reference

%--------------------------------------------------------------------------

name       = 'sample_d0_ok';
separation = 300;
optimize   = true;
center     = [0; (0.25 + 1.75)/2; 0];
scale      = 0.5;

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

load(['./' name '/imp_z_data.mat']);

stereoParams = data.stereoParams;

K1 = stereoParams.CameraParameters1.IntrinsicMatrix.';
K2 = stereoParams.CameraParameters2.IntrinsicMatrix.';
R2 = stereoParams.RotationOfCamera2;
t2 = -R2 * stereoParams.TranslationOfCamera2(:);

if (optimize)
    data_function = @(k1, k2, edges1, edges2)(imp_data_optimize(k1, k2, edges1, edges2, K1, K2, R2, t2));
    results       = 'optimize_300';
else
    data_function = @imp_data_direct;
    results       = 'direct_300';
end

edges1 = data.edges1;
edges2 = data.edges2;

N1 = size(edges1, 1);
N2 = size(edges2, 1);

offset = edges2(1, 6) - edges1(1, 6);
fixed  = separation - offset;

for k1 = 1:N1  
    k2 = k1 + fixed;
    if (k2 < 1), continue; elseif (k2 > N2), break; end
    
    if (~edges1(k1, 7) || ~edges2(k2, 7)), warning('skip'); continue; end
    
    p = data_function(k1, k2, edges1, edges2);
    
    pat1.row = edges1(k1, 6);
    pat2.row = edges2(k2, 6);
    
    [pat1, pat2] = pat_set1D_stereo(pat1, pat2, p);
    [pat1, pat2] = pat_extract_stereo(pmodel, K1, K2, pat1, pat2);
    [R_f,  t_f]  = pxp_v2(R2, t2, pat1, pat2);
    break;
end

im1 = imread(['./' name '/im1.png']);
im2 = imread(['./' name '/im2.png']);

[R2_g, t2_g] = pose_transform2(R_f, t_f, R2, t2);
[R2_w, t2_w] = pose_transform1(R2_g, t2_g);
[R_w,  t_w]  = pose_transform1(R_f, t_f);

imp_render_cube(center, scale, K1, R_w,  t_w,  im1, pat1.row, 'r');
imp_render_cube(center, scale, K2, R2_w, t2_w, im2, pat2.row, 'b');
