
clear all

simulation_reference

% -------------------------------------------------------------------------

s     = 0.5;
min_u = 64; % 64 128 256

% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

load(['./data/poses_1000_2000_' num2str(min_u) '.mat']);
load(['./data/noise_1000_' num2str(s) '.mat']);
load(['./data/rows_ogv_' num2str(min_u) '.mat']);

options = optimoptions('fmincon');

options.SpecifyConstraintGradient = true;
options.SpecifyObjectiveGradient  = true;
options.ConstraintTolerance       = 1e-10;
options.OptimalityTolerance       = 1e-10;
options.MaxFunctionEvaluations    = 1e6;
options.MaxIterations             = 1e5;

error_R1 = zeros(1000, 1);
error_T1 = zeros(1000, 1);
error_R2 = zeros(1000, 1);
error_T2 = zeros(1000, 1);
error_R3 = zeros(1000, 1);
error_T3 = zeros(1000, 1);
error_R4 = zeros(1000, 1);
error_T4 = zeros(1000, 1);
error_R5 = zeros(1000, 1);
error_T5 = zeros(1000, 1);
error_R6 = zeros(1000, 1);
error_T6 = zeros(1000, 1);
error_R7 = zeros(1000, 1);
error_T7 = zeros(1000, 1);
error_R8 = zeros(1000, 1);
error_T8 = zeros(1000, 1);

old_pattern_scale = 100;

parfor k_index = 1:1000
    pose  = old_pose_unpack(poses{k_index});
    
    R  = pose.R;
    t  = pose.T / old_pattern_scale;
    t2 = pose.R.'*(pose.RT2T - pose.T) / old_pattern_scale;
    R2 = pose.R.'*pose.RR2;
    
    row12 = rows(k_index, :);
    row1  = row12(1);
    row2  = row12(2);
    
    pat1 = old_pat_unpack(pose.C1(:, row1));
    pat2 = old_pat_unpack(pose.C2(:, row2));

    [pat1, pat2] = pat_add1D_stereo(pat1, pat2, [noise1(k_index, :), noise2(k_index, :)]);
    [pat1, pat2] = pat_extract_stereo(pmodel, K1, K2, pat1, pat2);

    [R_f1, T_f1] = pxp_v2(R2, t2, pat1, pat2);    
    [R_f2, T_f2] = pxp_x6(R2, t2, pat1, pat2);
    [R_f5, T_f5] = pxp_upnp(R2, t2, pat1, pat2);
    
    %[R_f7, T_f7, MRR] = NP3P_Q(pat1.A, pat1.pa, pat1.E, pat1.pe, pat2.A, pat2.pa, pat2.E, pat2.pe, K1, K2, R2, t2);
    %R_f7 = R_f7.';
    %T_f7 = -R_f7*(T_f7);
    
    flip1 = pat1.a > pat1.b;
    flip2 = pat2.a > pat2.b;
    
    if (flip1), pat1 = pat_flip(pat1); end
    if (flip2), pat2 = pat_flip(pat2); end
    
    [pat1, pat2] = model10_optimize(K1, K2, R2, t2, pat1, pat2, 3, options);
    
    if (flip1), pat1 = pat_flip(pat1); end
    if (flip2), pat2 = pat_flip(pat2); end
    
    [pat1, pat2] = pat_extract_stereo(pmodel, K1, K2, pat1, pat2);
    
    [R_f3, T_f3] = pxp_v2(R2, t2, pat1, pat2);
    [R_f4, T_f4] = pxp_x6(R2, t2, pat1, pat2);
    [R_f6, T_f6] = pxp_upnp(R2, t2, pat1, pat2);
    
    %[R_f8, T_f8, MRR] = NP3P_Q(pat1.A, pat1.pa, pat1.E, pat1.pe, pat2.A, pat2.pa, pat2.E, pat2.pe, K1, K2, R2, t2);
    %R_f8 = R_f8.';
    %T_f8 = -R_f8*(T_f8);
    
    R_f1 = real(R_f1);
    R_f2 = real(R_f2);
    R_f3 = real(R_f3);
    R_f4 = real(R_f4);
    R_f5 = real(R_f5);
    R_f6 = real(R_f6);
    %R_f7 = real(R_f7);
    %R_f8 = real(R_f8);
    
    T_f1 = real(T_f1);
    T_f2 = real(T_f2);
    T_f3 = real(T_f3);
    T_f4 = real(T_f4);
    T_f5 = real(T_f5);
    T_f6 = real(T_f6);
    %T_f7 = real(T_f7);
    %T_f8 = real(T_f8);
    
    [error_R1(k_index), error_T1(k_index)] = pose_compute_error(R, t, R_f1, T_f1);
    [error_R2(k_index), error_T2(k_index)] = pose_compute_error(R, t, R_f2, T_f2);
    [error_R3(k_index), error_T3(k_index)] = pose_compute_error(R, t, R_f3, T_f3);
    [error_R4(k_index), error_T4(k_index)] = pose_compute_error(R, t, R_f4, T_f4);
    [error_R5(k_index), error_T5(k_index)] = pose_compute_error(R, t, R_f5, T_f5);
    [error_R6(k_index), error_T6(k_index)] = pose_compute_error(R, t, R_f6, T_f6);
    %[error_R7(k_index), error_T7(k_index)] = pose_compute_error(R, t, R_f7, T_f7);
    %[error_R8(k_index), error_T8(k_index)] = pose_compute_error(R, t, R_f8, T_f8);
end

save(['results_ogv_' num2str(min_u) '_' num2str(s) '_final' '.mat'], ...
      'error_R1', 'error_T1', 'error_R2', 'error_T2', ...
      'error_R3', 'error_T3', 'error_R4', 'error_T4', ...
      'error_R5', 'error_T5', 'error_R6', 'error_T6', ...
      'error_R7', 'error_T7', 'error_R8', 'error_T8', ...
      '-v7.3');
