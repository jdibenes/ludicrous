
clear all

simulation_reference

%--------------------------------------------------------------------------

name       = 'sample_d1';
separation = 300;
optimize   = true;

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

R = data.R;
t = data.t;

edges1 = data.edges1;
edges2 = data.edges2;

N1 = size(edges1, 1);
N2 = size(edges2, 1);

offset = edges2(1, 6) - edges1(1, 6);
fixed  = separation - offset;

error = NaN(N1, 2);
ok    = false(N1, 1);

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
    
    error(k1, :) = pxp_compute_error(R, t, R_f, t_f);
    ok(k1)       = true;
end

final = error(ok, :);

save(['./' name '/' results '.mat'], 'error', 'ok', 'final');

disp(['min: '    num2str(min(final))]);
disp(['median: ' num2str(median(final))]);
disp(['mean: '   num2str(mean(final))]);
disp(['max: '    num2str(max(final))]);
