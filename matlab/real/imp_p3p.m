
function [R, t] = imp_p3p(pat2d, pat3d, camparam, mre)
[R, t] = estimateWorldCameraPose(pat2d, pat3d, camparam, 'MaxReprojectionError', mre);
R = R.';
t = t(:);
end
