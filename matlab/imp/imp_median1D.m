
function out = imp_median1D(l, n)
width = numel(l);
out = l;
for x = (1 + n):(width - n), out(x) = median(l(x + (-n:n))); end
end
