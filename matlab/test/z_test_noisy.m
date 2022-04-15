
clear all

options = optimoptions('fmincon');

%--------------------------------------------------------------------------

fname = 'pxp_z_testset.mat';
fname_noise = 'pxp_z_testset_noise.mat';
list  = {@pxp_v1; @pxp_v2; @pxp_x6; @pxp_upnp};
names = {'10-point (version 1)'; '10-point (version 2)'; '6-point'; 'upnp'};
s = 0.5;
refine = true;

options.MaxFunctionEvaluations = 1e6;
options.MaxIterations = 1e5;
options.OptimalityTolerance = 1e-10;

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

pose_s_load
load(fname_noise, 'noise_all');

N = numel(poses);
functions = size(list, 1);
error_all = zeros(N, 2, functions);

for k = 1:N
    disp(k);
    
    [R, t, pat1, pat2] = pose_unpack(poses{k});
    [pat1, pat2] = pat_add1D_stereo(pat1, pat2, noise_all{k}*s);
if (refine)
    [pat1, pat2] = model10_optimize(K1, K2, R2, t2, pat1, pat2, 3, options);
end
    [pat1, pat2] = pat_extract_stereo(pmodel, K1, K2, pat1, pat2);

for id = 1:functions
    f = list{id};
    
    [R_f, t_f] = f(R2, t2, pat1, pat2);
    
    error_Rt = pxp_compute_error(R, t, R_f, t_f);
    error_all(k, :, id) = [error_Rt(1), error_Rt(2) * 100];
end
end

disp('Median Error');

for id = 1:functions
    error_R = error_all(:, 1, id);
    error_t = error_all(:, 2, id);
    
    disp([names{id} ' R (deg): ' num2str(median(error_R(:))) ' t (%): ' num2str(median(error_t(:)))]);
end
