
%% Pattern ----------------------------------------------------------------

pmodel = pat_model(-1,    0, 0,  0,   1,  0, ...
                   -1, -0.5, 0,  0.5, 1,  1);
               
%% Cameras ----------------------------------------------------------------

K1 = [3100. 0. 1920.;
      0. 3100. 1080.;
      0.    0.    1.];
K2 = K1;

t2 = [-0.20; 0.02; -0.08];
R2 = rotx(1)*roty(2)*rotz(3);

width1  = 3840;
height1 = 2160;

width2  = 3840;
height2 = 2160;

fps = 60;

%% Synthetic generator ----------------------------------------------------

testcfg.min_y  = 0.10;
testcfg.max_y  = 1.90;
testcfg.scale  = 100*norm(t2);
testcfg.offset = [0; testcfg.min_y + testcfg.max_y; 0] / 2;
testcfg.min_z  = 0;
testcfg.min_dy = 0.05;
testcfg.min_du = 64;
testcfg.max_du = 128;
testcfg.dv     = height1 / 6;
testcfg.select = true(5, 1);
