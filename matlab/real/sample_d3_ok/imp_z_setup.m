
%--------------------------------------------------------------------------

calibration = 'stereoParamsFinal.mat';

roi1 = [1540, 900; 1470, 1549];
roi2 = [1240, 770; 1140, 1440];

sigma = 2;

th1 = 0.4;
th2 = 0.8;

roiul = [1580,  865, 20, 20];
roium = [2045,  865, 20, 20];
roiur = [2530,  870, 20, 20];
roibl = [1510, 1560, 20, 20];
roibm = [2015, 1575, 15, 20];
roibr = [2540, 1590, 20, 20];

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