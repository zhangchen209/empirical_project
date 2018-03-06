function [y x] = dgp(n,beta)

rng('default');

mu = [0;0;0];
sigma = eye(3);
x = mvnrnd(mu,sigma,n);
x = [ones(n,1) x]';
u = normrnd(0,1,[n,1]);
u = x(2)^2*u;

y_star = x'*beta +u;

y = max(0,y_star);