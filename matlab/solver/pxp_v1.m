
function [R, t] = pxp_v1(R2, t2, pat1, pat2)
X1 = pxp_circles_intersection(pat1.fa, pat1.fc, pat1.fe, pat1.A, pat1.C, pat1.E);
X2 = pxp_circles_intersection(pat2.fa, pat2.fc, pat2.fe, pat2.A, pat2.C, pat2.E);

s1a = pxp_circles_distances(X1, pat1.A, pat1.A);
s1e = pxp_circles_distances(X1, pat1.A, pat1.E);
s2a = pxp_circles_distances(X2, pat2.A, pat2.A);

pA1 = s1a * pat1.fa;
pE1 = s1e * pat1.fe;
pA2 = s2a * R2 * pat2.fa + t2;

R = pxp_R_inverse(pA1, pE1, pA2, pat1.A, pat1.E, pat2.A);
t = pxp_t_equation(R, pA1, pat1.A);
end
