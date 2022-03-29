
function [R, t, pat1, pat2] = pose_unpack(data)
pat_len = pat_pack_query();

o12 =  13 + pat_len - 1;
o21 = o12 + 1;
o22 = o21 + pat_len - 1;

R    = reshape(data( 1: 9), [3, 3]);
t    = reshape(data(10:12), [3, 1]);
pat1 = pat_unpack(data( 13:o12));
pat2 = pat_unpack(data(o21:o22));
end
