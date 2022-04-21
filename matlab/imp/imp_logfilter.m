
function f = imp_logfilter(sigma)
half = ceil(sigma * 3);
x = -half:half;
f = exp(-(x.^2)/(2*sigma^2)) .* (x.^2 - sigma^2);
f = f - (sum(f) / numel(f));
f = f / max(abs(f));
end
