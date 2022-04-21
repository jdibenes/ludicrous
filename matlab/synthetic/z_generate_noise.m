
clear all

N = 1000;
s = 0.5;

noise1 = s*randn(N, 5);
noise2 = s*randn(N, 5);

save(['noise_' num2str(N) '_' num2str(s) '.mat']);
