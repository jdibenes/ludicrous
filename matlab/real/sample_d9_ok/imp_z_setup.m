
%--------------------------------------------------------------------------

calibration = 'stereoParamsFinal.mat';

roi1 = [1490, 930; 1470, 1580];
roi2 = [1180, 820; 1160, 1460];

sigma = 2;

th1 = 0.4;
th2 = 0.8;

roiul = [1535,  875, 20, 20];
roium = [1990,  895, 20, 20];
roiur = [2420,  910, 20, 25];
roibl = [1520, 1585, 25, 25];
roibm = [1990, 1585, 25, 25];
roibr = [2435, 1585, 20, 20];

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