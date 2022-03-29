
function ok = pose_constraint_y(pat1, pat2, min_y, max_y)
min_ok = (pat1.Pa(2) > min_y) && (pat1.Pe(2) > min_y) && (pat2.Pa(2) > min_y) && (pat2.Pe(2) > min_y);
max_ok = (pat1.Pa(2) < max_y) && (pat1.Pe(2) < max_y) && (pat2.Pa(2) < max_y) && (pat2.Pe(2) < max_y);
ok = min_ok && max_ok;
end
