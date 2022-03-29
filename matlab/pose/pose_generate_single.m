
function [R, t, pat1, pat2] = pose_generate_single(pmodel, K1, K2, R2, t2, height1, height2, scale, offset, constraints, dv)
while (true)
    [R, t] = pose_random_Rt(scale, offset);
    [R2_g, t2_g] = pose_transform2(R, t, R2, t2);
    
                      row1 = randi(height1) - 1;
    if (isempty(dv)), row2 = randi(height2) - 1; 
    else,             row2 = mod(row1 + dv, height2); end
    
    [pat1, pat2] = pat_real_stereo(pmodel, K1, K2, R, R2_g, t, t2_g, row1, row2);
    if (pose_evaluate_constraints(constraints, pat1, pat2)), break; end
end
end
