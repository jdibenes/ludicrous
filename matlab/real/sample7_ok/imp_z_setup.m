
%--------------------------------------------------------------------------

calibration = 'stereoParams.mat';

roi1 = [770, 590; 660, 1770];
roi2 = [200, 500;  30, 1680];

sigma = 2;

th1 = 0.4;
th2 = 0.8;

roiul = [ 860,  410, 50, 40];
roium = [1760,  490, 20, 15];
roiur = [2540,  540, 50, 40];
roibl = [ 750, 1780, 50, 40];
roibm = [1770, 1790, 20, 20];
roibr = [2650, 1770, 50, 40];

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
