
function ok = pose_constraint_depth(pat1, pat2, min_z)
u_ok = isfinite(pat1.a) && isfinite(pat1.e) && isfinite(pat2.a) && isfinite(pat2.e);
z_ok = (pat1.za > min_z) && (pat1.ze > min_z) && (pat2.za > min_z) && (pat2.ze > min_z);
ok = u_ok && z_ok; 
end
