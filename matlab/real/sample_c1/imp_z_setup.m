
%--------------------------------------------------------------------------

roi1 = [2225, 870; 1910, 1605];
roi2 = [1860, 750; 1510, 1490];

sigma = 2;

th1 = 0.23;
th2 = 0.155;

roiul = [2262,  835, 15, 15];
roium = [2615,  685, 15, 15];
roiur = [3145,  460, 20, 15];
roibl = [1920, 1633, 15, 20];
roibm = [2235, 1643, 20, 20];
roibr = [2743, 1663, 15, 20];

pat3d = [[-1, 1.75, 0];
         [ 0, 1.75, 0];
         [ 1, 1.75, 0];
         [-1, 0.25, 0];
         [ 0, 0.25, 0];
         [ 1, 0.25, 0]];
     
badrows1 = [];
badrows2 = [1465, 1469];
     
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^