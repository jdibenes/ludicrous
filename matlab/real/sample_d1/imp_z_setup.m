
%--------------------------------------------------------------------------

calibration = 'stereoParamsFinal.mat';

roi1 = [1240, 410; 1150, 1980];
roi2 = [ 600, 300;  450, 1850];

sigma = 2;

th1 = 0.4;
th2 = 0.8;

roiul = [1330,  385, 15, 20];
roium = [2360,  385, 15, 15];
roiur = [3425,  375, 20, 20];
roibl = [1240, 1990, 15, 15];
roibm = [2380, 2015, 15, 15];
roibr = [3570, 2040, 15, 15];

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