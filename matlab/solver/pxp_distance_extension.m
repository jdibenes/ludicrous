
function y = pxp_distance_extension(x, P1, P2, P3, P4, P5, p2, p3, p4)
s3 = (norm(P3 - P5)*x(1) + norm(P1 - P3)*x(2)) / norm(P1 - P5);

s2 = (s3*norm(P2 - P4)*(p3 - p4))/((p2 - p4)*norm(P3 - P4));
s4 = (s3*norm(P2 - P4)*(p2 - p3))/((p2 - p4)*norm(P2 - P3));

y = [s2, s3, s4];
end


%p1,
%, p5
%y(1) = x(1) * ((p1 - p3) * norm(P2 - P3)) / ((p2 - p3) * norm(P1 - P3));
%y(2) = x(1) * ((p1 - p2) * norm(P2 - P3)) / ((p2 - p3) * norm(P1 - P2));
%y(3) = x(1) * ((p1 - p3) * norm(P3 - P4)) / ((p3 - p4) * norm(P1 - P3));