clear, clc;



seed = randseed(133);
beta = [6;6;6;6];
n = 100;

[y x] = dgp(n,beta,seed);
L= @(b)(-sum(abs(y-max(0,x'*b))));

b = 0.1:0.1:10;

