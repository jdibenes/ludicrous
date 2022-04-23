
clear all

simulation_reference

%--------------------------------------------------------------------------

name          = 'sample4_ok';
data_function = @imp_data_direct;
pattern_scale = 100;

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

load(['./' name '/imp_z_data.mat']);

stereoParams = data.stereoParams;

K1 = stereoParams.CameraParameters1.IntrinsicMatrix.';
K2 = stereoParams.CameraParameters2.IntrinsicMatrix.';
R2 = stereoParams.RotationOfCamera2;
t2 = -R2 * stereoParams.TranslationOfCamera2(:) / pattern_scale;

R = data.R;
t = data.t;

edges1 = data.edges1;
edges2 = data.edges2;

N1 = size(edges1, 1);
N2 = size(edges2, 1);

results = cell(1, 6);
index   = 0;

for separation = 100:100:600
offset = edges2(1, 6) - edges1(1, 6);
fixed  = separation - offset;

error = zeros(N1, 2);
ok = false(N1, 1);

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

index = index + 1;
results{index} = final;
end

data = NaN(N1, 2, 6);

for index = 1:6, data(1:size(results{index}, 1), :, index) = results{index}; end

figure();
boxplot(reshape(data(:, 1, :), [N1, 6]), {'100', '200', '300', '400', '500', '600'});
ylim([0, 3]);
xlabel('Row separation');
ylabel('Error (degrees)');
title('Orientation error for real pair no. 1');
drawnow

figure();
boxplot(reshape(data(:, 2, :) * 100, [N1, 6]), {'100', '200', '300', '400', '500', '600'});
ylim([0, 6]);
xlabel('Row separation');
ylabel('Error (%)');
title('Translation relative error for real pair no. 1');
