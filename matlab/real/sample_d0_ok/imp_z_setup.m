
%--------------------------------------------------------------------------

calibration = 'stereoParamsFinal.mat';

roi1 = [1090, 700; 1250, 1610];
roi2 = [ 290, 570;  490, 1490];

sigma = 2;

th1 = 0.4;
th2 = 0.8;

roiul = [1045,  310, 25, 30];
roium = [1310,  530, 15, 20];
roiur = [1465,  655, 10, 10];
roibl = [1365, 2085, 20, 15];
roibm = [1545, 1810, 20, 15];
roibr = [1649, 1653,  8,  9];

pat3d = [[-1, 1.75, 0];
         [ 0, 1.75, 0];
         [ 1, 1.75, 0];
         [-1, 0.25, 0];
         [ 0, 0.25, 0];
         [ 1, 0.25, 0]];
     
select = [1, 2, 3];
     
badrows1 = [];
badrows2 = [];
     
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^