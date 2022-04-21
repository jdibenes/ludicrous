
function [pat1, pat2] = model10_optimize(K1, K2, R2, t2, pat1, pat2, du, options)
x_start = [(pat_get1D(pat1) - K1(1, 3)) / K1(1, 1); (pat_get1D(pat2) - K2(1, 3)) / K2(1, 1)];

f_objective = @(x)(model10_delta(x, x_start));
f_nonlcon = @(x)(model10_lines(x, R2, t2, (pat1.row - K1(2, 3)) / K1(2, 2), (pat2.row - K2(2, 3)) / K2(2, 2)));

x = fmincon(f_objective, x_start, [], [], [], [], x_start - du, x_start + du, f_nonlcon, options);

x_end = [x(1:5) * K1(1, 1) + K1(1, 3); x(6:10) * K2(1, 1) + K2(1, 3)];
[pat1, pat2] = pat_set1D_stereo(pat1, pat2, x_end);
end
