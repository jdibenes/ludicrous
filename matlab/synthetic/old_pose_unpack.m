
function pose = old_pose_unpack(posep)
pose.R    = reshape(posep(1:9),   [3, 3]);
pose.T    = posep(10:12);
pose.RT2T = posep(13:15);
pose.RR2  = reshape(posep(16:24), [3, 3]);

sz1 = posep(25);
sz2 = posep(26);

fs1 = 27;
ls1 = fs1 + (sz1 * 26) - 1;
fs2 = ls1 + 1;
ls2 = fs2 + (sz2 * 26) - 1;

pose.C1 = reshape(posep(fs1:ls1), [26, sz1]);
pose.C2 = reshape(posep(fs2:ls2), [26, sz2]);
end
