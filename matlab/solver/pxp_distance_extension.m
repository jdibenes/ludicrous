
function y = pxp_distance_extension(x, P1, P2, P3, P4, p1, p2, p3, p4)
y(1) = x(1) * ((p1 - p3) * norm(P2 - P3)) / ((p2 - p3) * norm(P1 - P3));
y(2) = x(1) * ((p1 - p2) * norm(P2 - P3)) / ((p2 - p3) * norm(P1 - P2));
y(3) = x(1) * ((p1 - p3) * norm(P3 - P4)) / ((p3 - p4) * norm(P1 - P3));
end
