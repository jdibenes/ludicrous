
function p = imp_data_optimize(k1, k2, edges1, edges2, K1, K2, R2, t2)
options = optimoptions('fmincon');

options.SpecifyConstraintGradient = true;
options.SpecifyObjectiveGradient  = true;
options.ConstraintTolerance       = 1e-10;
options.OptimalityTolerance       = 1e-10;
options.MaxFunctionEvaluations    = 1e6;
options.MaxIterations             = 1e5;

pat1.row = edges1(k1, 6);
pat2.row = edges2(k2, 6);

[pat1, pat2] = pat_set1D_stereo(pat1, pat2, [edges1(k1, 1:5), edges2(k2, 1:5)].');
[pat1, pat2] = model10_optimize(K1, K2, R2, t2, pat1, pat2, 3, options);

p = pat_get1D_stereo(pat1, pat2);
end
