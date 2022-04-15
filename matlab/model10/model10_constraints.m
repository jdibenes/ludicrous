
clear all

simulation_reference

%% Camera 1 (Normalized coordinates)

u1a = sym('u1a', 'real'); 
u1b = sym('u1b', 'real'); 
u1c = sym('u1c', 'real'); 
u1d = sym('u1d', 'real'); 
u1e = sym('u1e', 'real');

assumeAlso(u1a < u1b & u1b < u1c & u1c < u1d & u1d < u1e);

row1 = sym('row1', 'real');

%% Camera 2 (Normalized coordinates)

u2a = sym('u2a', 'real'); 
u2b = sym('u2b', 'real'); 
u2c = sym('u2c', 'real'); 
u2d = sym('u2d', 'real'); 
u2e = sym('u2e', 'real');

assumeAlso(u2a < u2b & u2b < u2c & u2c < u2d & u2d < u2e);

row2 = sym('row2', 'real');

%% Stereo

t2 = sym('t2_', [3, 1], 'real');
R2 = sym('R2_', [3, 3], 'real');

assumeAlso(R2.' * R2 == eye(3));

assumeAlso( dot(R2(1, :), cross(R2(2, :), R2(3, :))) == 1);
assumeAlso(-dot(R2(2, :), cross(R2(1, :), R2(3, :))) == 1);
assumeAlso( dot(R2(3, :), cross(R2(1, :), R2(2, :))) == 1);

assumeAlso( dot(R2(:, 1), cross(R2(:, 2), R2(:, 3))) == 1);
assumeAlso(-dot(R2(:, 2), cross(R2(:, 1), R2(:, 3))) == 1);
assumeAlso( dot(R2(:, 3), cross(R2(:, 1), R2(:, 2))) == 1);

%% Distances

pat1 = [];
pat2 = [];

pat1.row = row1;
pat2.row = row2;

[pat1, pat2] = pat_set1D_stereo(pat1, pat2, [u1a, u1b, u1c, u1d, u1e, u2a, u2b, u2c, u2d, u2e]);
[pat1, pat2] = pat_extract_stereo(pmodel, eye(3), eye(3), pat1, pat2);

X1 = pxp_distance_collinear(pat1.A, pat1.C, pat1.E, pat1.na, pat1.nc, pat1.ne);
X2 = pxp_distance_collinear(pat2.A, pat2.C, pat2.E, pat2.na, pat2.nc, pat2.ne);

Y1 = pxp_distance_extension(X1, pat1.A, pat1.B, pat1.C, pat1.D, pat1.E, u1b, u1c, u1d);
Y2 = pxp_distance_extension(X2, pat2.A, pat2.B, pat2.C, pat2.D, pat2.E, u2b, u2c, u2d);

X1 = simplify(X1);
Y1 = simplify(Y1);
X2 = simplify(X2);
Y2 = simplify(Y2);

%% Constraints

pA1 = X1(1) * pat1.na;
pB1 = Y1(1) * pat1.nb;
pC1 = Y1(2) * pat1.nc;
pD1 = Y1(3) * pat1.nd;
pE1 = X1(2) * pat1.ne;

pA2 = X2(1) * R2 * pat2.na + t2;
pB2 = Y2(1) * R2 * pat2.nb + t2;
pC2 = Y2(2) * R2 * pat2.nc + t2;
pD2 = Y2(3) * R2 * pat2.nd + t2;
pE2 = X2(2) * R2 * pat2.ne + t2;

%% Lines on pattern

laa = simplify(pA1 - pA2);
lbb = simplify(pB1 - pB2);
lcc = simplify(pC1 - pC2);
ldd = simplify(pD1 - pD2);
lee = simplify(pE1 - pE2);

raa = simplify(pat1.A - pat2.A);
rbb = simplify(pat1.B - pat2.B);
rcc = simplify(pat1.C - pat2.C);
rdd = simplify(pat1.D - pat2.D);
ree = simplify(pat1.E - pat2.E);

%% Constraints

variables_u     = [u1a; u1b; u1c; u1d; u1e; u2a; u2b; u2c; u2d; u2e];
variables_u_all = [variables_u; row1; row2; t2(:); R2(:)];

saa  = (sum(laa.^2)) - (sum(raa.^2));
matlabFunction( saa, 'Vars', variables_u_all, 'File', 'model10_saa.m' );

sbb  = (sum(lbb.^2)) - (sum(rbb.^2));
matlabFunction( sbb, 'Vars', variables_u_all, 'File', 'model10_sbb.m' );

scc  = (sum(lcc.^2)) - (sum(rcc.^2));
matlabFunction( scc, 'Vars', variables_u_all, 'File', 'model10_scc.m' );

sdd  = (sum(ldd.^2)) - (sum(rdd.^2));
matlabFunction( sdd, 'Vars', variables_u_all, 'File', 'model10_sdd.m' );

see  = (sum(lee.^2)) - (sum(ree.^2));
matlabFunction( see, 'Vars', variables_u_all, 'File', 'model10_see.m' );

gsaa = gradient(saa, variables_u);
matlabFunction(gsaa, 'Vars', variables_u_all, 'File', 'model10_gsaa.m');

gsbb = gradient(sbb, variables_u);
matlabFunction(gsbb, 'Vars', variables_u_all, 'File', 'model10_gsbb.m');

gscc = gradient(scc, variables_u);
matlabFunction(gscc, 'Vars', variables_u_all, 'File', 'model10_gscc.m');

gsdd = gradient(sdd, variables_u);
matlabFunction(gsdd, 'Vars', variables_u_all, 'File', 'model10_gsdd.m');

gsee = gradient(see, variables_u);
matlabFunction(gsee, 'Vars', variables_u_all, 'File', 'model10_gsee.m');

%% Objective function for minimization of reprojection error in x

m1a = sym('m1a', 'real');
m1b = sym('m1b', 'real');
m1c = sym('m1c', 'real');
m1d = sym('m1d', 'real');
m1e = sym('m1e', 'real');

m2a = sym('m2a', 'real');
m2b = sym('m2b', 'real');
m2c = sym('m2c', 'real');
m2d = sym('m2d', 'real');
m2e = sym('m2e', 'real');

f = (u1a-m1a)^2 + (u1b-m1b)^2 + (u1c-m1c)^2 + (u1d-m1d)^2 + (u1e-m1e)^2 ...
  + (u2a-m2a)^2 + (u2b-m2b)^2 + (u2c-m2c)^2 + (u2d-m2d)^2 + (u2e-m2e)^2;

gf = gradient(f, variables_u);

variables_k_all = [variables_u; m1a; m1b; m1c; m1d; m1e; m2a; m2b; m2c; m2d; m2e];

matlabFunction( f, 'Vars', variables_k_all, 'File', 'model10_f.m' );
matlabFunction(gf, 'Vars', variables_k_all, 'File', 'model10_gf.m');
