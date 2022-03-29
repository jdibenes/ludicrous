
function R = pxp_R_inverse(Q11, Q12, Q21, P11, P12, P21)
l1 = Q11 - Q12;
l2 = Q11 - Q21;
l3 = cross(l1, l2);

l = [l1, l2, l3];

r1 = P11 - P12;
r2 = P11 - P21;
r3 = cross(r1, r2);

r = [r1, r2, r3];

R = r / l;
end
