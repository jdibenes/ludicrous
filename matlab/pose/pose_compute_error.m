
function [err_R, err_T] = pose_compute_error(R_gt, t_gt, R, t)
err_R = rotm2axang(R_gt.' * R);
err_R = rad2deg(err_R(4));
err_T = norm(t_gt - t) / norm(t_gt);
end
