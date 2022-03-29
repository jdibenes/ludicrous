
function ok = pose_evaluate_constraints(constraints, pat1, pat2)
ok = false;
for f = constraints(:).'
    c = f{1};
    if (~c(pat1, pat2)), return; end
end
ok = true;
end
