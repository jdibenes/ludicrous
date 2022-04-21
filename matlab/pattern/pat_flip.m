
function pat = pat_flip(pat)
pat = pat_set1D(pat, fliplr(pat_get1D(pat).'));
end
