
function ok = pose_constraint_du(pat1, pat2, min_du, max_du)
ab1 = abs(pat1.a - pat1.b);
bc1 = abs(pat1.b - pat1.c);
cd1 = abs(pat1.c - pat1.d);
de1 = abs(pat1.d - pat1.e);

ab2 = abs(pat2.a - pat2.b);
bc2 = abs(pat2.b - pat2.c);
cd2 = abs(pat2.c - pat2.d);
de2 = abs(pat2.d - pat2.e);

dp = min([ab1, bc1, cd1, de1, ab2, bc2, cd2, de2]);

ok = dp > min_du && dp <= max_du;
end
