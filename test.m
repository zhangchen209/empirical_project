clear, clc;



beta = [-6;3;3;3];
tau = 0.5;
y_c = 0;
d = length(beta);
n = 400;
R = 100;
seed = randseed(133,R);

% generate data
y = zeros(n,R);
x = zeros(n,d,R);
for i=1:R
    [y(:,i) x(:,:,i)] = dgp(n,beta,seed(i));
end
initval = zeros(4,R);
for i=1:R
    initval(:,i) = (x(:,:,i)'*x(:,:,i))\x(:,:,i)'*y(:,i);
end

prmax = [4;13;13;13];
prmin = [-16;-7;-7;-7];

% MCMC run
burnin = 10000;
keep = 10000;
r = 99;
theta_1 = zeros(keep,4,R);
iaccept = zeros(r,1);
theta1_mean = zeros(R,4);
theta_lte = zeros(R,4);
y = y(:,r);
x = x(:,:,r);
initval = initval(:,r);
theta = zeros(keep,4);
ehat = y - x*initval;
n = length(y);
promu = zeros(4,1);
prosig = eye(4);
prosig = chol(prosig);
ehat_sq  = mean(ehat.^2);
cov = ehat_sq^2*(x'*x)^(-1);
cov_chol = chol(cov)';

% post = @(t) n*obj(y,x,t); %+ sum(log(unifpdf(t,prmin,prmax)));
curr_pi = n*obj(y,x,initval,tau);
curr_theta = initval;

b = 2;
iaccept = 0;



%% MCMC run
while b<= burnin
    e = randn(4,1);
    propose = curr_theta + cov_chol*e;
    prop_pi = n*obj(y,x,propose,tau);
    if prop_pi == NaN;
        prop_pi = -1000000;
    end
    u = unifrnd(0,1);
    u = log(u);
    if u < prop_pi - curr_pi;
        curr_theta = propose;
        curr_pi = prop_pi;
    end
    
    b = b+1;
end

theta(1,:) = curr_theta';
k = 2;
while k<= keep
    e = randn(4,1);
    propose = theta(k-1,:)' + cov_chol*e;
    prop_pi = n*obj(y,x,propose,tau);
    if prop_pi == NaN;
        prop_pi = -999999;
    end
    u = unifrnd(0,1);
    u = log(u);
    if u < prop_pi - curr_pi;
        iaccept = iaccept + 1;
        theta(k,:) = propose';
        curr_pi = prop_pi;
    else theta(k,:) = theta(k-1,:);
    end
    
    k = k+1;
end
