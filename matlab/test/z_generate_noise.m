
clear all

%--------------------------------------------------------------------------

fname = 'pxp_z_testset.mat';
fname_out = 'pxp_z_testset_noise.mat';

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

pose_s_load

noise_all = pose_generate_noise(poses, @randn);

save(fname_out, 'noise_all');
