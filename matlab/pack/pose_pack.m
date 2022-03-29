
function data = pose_pack(R, t, pat1, pat2)
data = [R(:); t(:); pat_pack(pat1); pat_pack(pat2)];
end
