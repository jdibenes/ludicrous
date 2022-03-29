
function s = pxp_circles_distances(p, P1, P)
s = norm([p(1) - norm(P1 - P); p(2)]);
end
