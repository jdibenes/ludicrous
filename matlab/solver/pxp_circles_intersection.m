
function p = pxp_circles_intersection(f1, f2, f3, P1, P2, P3)
P2_b = norm(P1 - P2);
P3_b = norm(P1 - P3);

cosO_12 = dot(f1, f2);
cosO_13 = dot(f1, f3);

sinO_12 = sqrt(1 - cosO_12^2);
sinO_13 = sqrt(1 - cosO_13^2);

num = P2_b * cosO_12 * sinO_13 - P3_b * cosO_13 * sinO_12;
den = (P3_b - P2_b) * sinO_12 * sinO_13;

alpha = atan2(num, den);
cos_a = cos(alpha);
sin_a = sin(alpha);

cotO_12 = cosO_12 / sinO_12; % unbounded

p(1) = P2_b * ( 1       - (cos_a - cotO_12 * sin_a) * cos_a);
p(2) = P2_b * (-cotO_12 - (cos_a - cotO_12 * sin_a) * sin_a);
end
