
function p = pose_project(K, R, t, P)
p = K * pose_transform(R, t, P);
end
