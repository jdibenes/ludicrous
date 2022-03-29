
function constraints = pose_constraints(select, min_z, min_y, max_y, min_dy, min_du, max_du, width1, width2)
constraints = {
    @(pat1, pat2)(pose_constraint_depth(pat1, pat2, min_z));
    @(pat1, pat2)(pose_constraint_y(    pat1, pat2, min_y, max_y));
    @(pat1, pat2)(pose_constraint_dy(   pat1, pat2, min_dy));
    @(pat1, pat2)(pose_constraint_du(   pat1, pat2, min_du, max_du));
    @(pat1, pat2)(pose_constraint_image(pat1, pat2, width1, width2));
};

constraints = constraints(select);
end
