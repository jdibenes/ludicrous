
function poses = pose_sequence(pmodel, K1, K2, R, R2, t, t2, sequence, update, user, constraints)
poses = zeros(size(sequence, 1), pose_pack_query());
k = 0;

for pair = sequence.'
    [R2_g, t2_g] = pose_transform2(R, t, R2, t2);
    [pat1, pat2] = pat_real_stereo(pmodel, K1, K2, R, R2_g, t, t2_g, pair(1), pair(2));
    
    if (pose_evaluate_constraints(constraints, pat1, pat2))
        k = k + 1;
        poses(k, :) = pose_pack(R, t, pat1, pat2);
    end
    
    [R, t, user] = update(R, t, user); 
end

poses = poses(1:k, :);
end
