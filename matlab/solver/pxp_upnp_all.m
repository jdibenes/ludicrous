
function [R, t] = pxp_upnp_all(R2, t2, pat1, pat2)
P = [     pat1.A,      pat1.E,     pat2.A  ];
f = [[    pat1.fa,     pat1.fe, R2*pat2.fa];
     [zeros(3, 1), zeros(3, 1), t2        ]];

X = opengv('upnp', P, f);

N = size(X, 3);

R = zeros(3, 3, N);
t = zeros(3, N);

for k = 1:N
    R(:, :, k) = X(:, 1:3, k);
    t(:,    k) = X(:,   4, k);
end
end
