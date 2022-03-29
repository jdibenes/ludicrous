
function ok = pose_constraint_image(pat1, pat2, width1, width2)
min_ok = (pat1.a >      0) && (pat1.e >      0) && (pat2.a >      0) && (pat2.e >      0);
max_ok = (pat1.a < width1) && (pat1.e < width1) && (pat2.a < width2) && (pat2.e < width2);
ok = min_ok && max_ok;
end
