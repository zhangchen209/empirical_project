function [Y,D,X,Z] = dgp(N,rho,delta,beta,gamma)

X = mvnrnd(zeros(9,1),eye(9),N)';
Z = randn(N,1);

s = mvnrnd([1;0],[1,rho;rho,1],N);
y0 = s(:,1) + X'*beta;
y1 = y0 + s(:,1);
D = s(:,2)<=X'*gamma+Z*delta;

Y = D.*y1+(1-D).*y0;
X = [ones(1,N);X]';


end