
function ok = pose_constraint_dy(pat1, pat2, min_dy)
ok = (abs(pat1.Pa(2) - pat2.Pa(2)) > min_dy) && (abs(pat1.Pe(2) - pat2.Pe(2)) > min_dy);
end
