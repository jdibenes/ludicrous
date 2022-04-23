
function data = pose_generate_sequence(pmodel, K1, K2, R2, t2, height1, height2, scale, offset, update, user, constraints, dv)
[R, t, pat1, pat2] = pose_generate_single(pmodel, K1, K2, R2, t2, height1, height2, scale, offset, constraints, dv);

row1 = pat1.row;
row2 = pat2.row;

sequence1 = [row1:(height1 - 1), 0:(row1 - 1)];
sequence2 = mod(row2 + (0:(numel(sequence1) - 1)), height2);

sequence = [sequence1(:), sequence2(:)];

data = pose_sequence(pmodel, K1, K2, R, R2, t, t2, sequence, update, user, constraints);
end
