
function pat = pat_unpack(p)
pat.row = p(6);
pat = pat_set1D(pat, p(1:5));
end
