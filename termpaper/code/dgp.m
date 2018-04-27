function [y x] = dgp(n,beta,seed)

rng(seed);

x = randn(n,3);
x = [ones(n,1) x];
u = randn(n,1);
u = x(:,2).^2.*u;

y_star = x*beta +u;

y = max(0,y_star);