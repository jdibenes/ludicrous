
function [pat1, pat2] = pat_add1D_stereo(pat1, pat2, vector)
pat1 = pat_add1D(pat1, vector(1: 5));
pat2 = pat_add1D(pat2, vector(6:10));
end
