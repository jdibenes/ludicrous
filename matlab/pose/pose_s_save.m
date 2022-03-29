
poses_bank.pmodel  = pmodel;
poses_bank.K1      = K1;
poses_bank.K2      = K2;
poses_bank.t2      = t2;
poses_bank.R2      = R2;
poses_bank.width1  = width1;
poses_bank.height1 = height1;
poses_bank.width2  = width2;
poses_bank.height2 = height2;
poses_bank.fps     = fps;
poses_bank.testcfg = testcfg;
poses_bank.poses   = poses;

save(fname, 'poses_bank', '-v7.3');
