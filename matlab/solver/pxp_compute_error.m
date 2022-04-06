
function error = pxp_compute_error(R_gt, t_gt, R, t)
error_R = rotm2axang(R.' * R_gt);
error_R = rad2deg(error_R(4));    
error_t = norm(t_gt - t) / norm(t_gt);
error = [error_R, error_t];
end
