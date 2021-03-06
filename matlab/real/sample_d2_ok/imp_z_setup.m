
%--------------------------------------------------------------------------

calibration = 'stereoParamsFinal.mat';

roi1 = [1840, 890; 1850, 1780];
roi2 = [1420, 770; 1400, 1660];

sigma = 2;

th1 = 0.4;
th2 = 0.8;

roiul = [1885,  850, 15, 10];
roium = [2470,  660, 15, 15];
roiur = [3265,  400, 15, 15];
roibl = [1905, 1890, 20, 15];
roibm = [2560, 1865, 15, 15];
roibr = [3485, 1820, 25, 20];

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
