
clear all

%--------------------------------------------------------------------------

fname = 'pxp_z_testset.mat';
N     = [];
list  = {@pxp_v1; @pxp_v2; @pxp_x6};
names = {'10-point (version 1)'; '10-point (version 2)'; '6-point'};

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

pose_s_load

if (isempty(N)), N = numel(poses); end

functions = size(list, 1);
error = zeros(N, 2, functions);

for k = 1:N
    disp(k);
    
    [R, t, pat1, pat2] = pose_unpack(poses{k});    
    [pat1, pat2] = pat_extract_stereo(pmodel, K1, K2, pat1, pat2);
    
for id = 1:functions
    f = list{id};
    
    [R_f, t_f] = f(R2, t2, pat1, pat2);
    
    error_R = R - R_f;
    error_t = t - t_f;
    
    error(k, :, id) = [max(abs(error_R(:))), max(abs(error_t))];
end
end

disp('Maximum Absolute Error');

for id = 1:functions
    error_R = error(:, 1, id);
    error_t = error(:, 2, id);
    
    disp([names{id} ' R: ' num2str(max(error_R(:))) ' t: ' num2str(max(error_t(:)))]);
end
