
clear all

simulation_reference

for min_u = [64, 128, 256]
load(['poses_1000_2000_' num2str(min_u) '.mat']);
rows = zeros(1000, 2);

parfor k_index = 1:1000
    disp(k_index);

    pose = pose_unpack(poses{k_index});
    
    row1 = 1 + fix(rand() * (size(pose.C1, 2) - 1));
    row2 = 1 + fix(rand() * (size(pose.C2, 2) - 1));
    
    rows(k_index, :) = [row1, row2];
end

save(['rows_ogv_' num2str(min_u) '.mat'], 'rows', '-v7.3');
end
