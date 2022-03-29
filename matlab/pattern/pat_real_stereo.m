
function [pat1, pat2] = pat_real_stereo(pmodel, K1, K2, R, R2_g, t, t2_g, row1, row2)
pat1 = pat_real(pmodel, K1, R,    t,    row1);
pat2 = pat_real(pmodel, K2, R2_g, t2_g, row2);
end
