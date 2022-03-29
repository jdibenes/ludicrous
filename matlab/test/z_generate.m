
clear all

simulation_reference

%--------------------------------------------------------------------------

fname = 'pxp_z_testset.mat';
N     = 10;

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

constraints = pose_constraints(testcfg.select, testcfg.min_z, testcfg.min_y, testcfg.max_y, testcfg.min_dy, testcfg.min_du, testcfg.max_du, width1, width2);
poses = cell(N, 1);

for k = 1:N
    disp(k);
    [R, t, pat1, pat2] = pose_generate_single(pmodel, K1, K2, R2, t2, height1, height2, testcfg.scale, testcfg.offset, constraints, []);
    poses{k} = pose_pack(R, t, pat1, pat2);
end

pose_s_save
