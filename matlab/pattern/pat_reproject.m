
function pat = pat_reproject(K, R_w, t_w, pat)
pat.qa = pose_project(K, R_w, t_w, pat.A);
pat.qb = pose_project(K, R_w, t_w, pat.B);
pat.qc = pose_project(K, R_w, t_w, pat.C);
pat.qd = pose_project(K, R_w, t_w, pat.D);
pat.qe = pose_project(K, R_w, t_w, pat.E);
end
