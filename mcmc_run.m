function [theta iaccept] = mcmc_run(burnin,keep,y,x,initval,seed)

rng(seed);
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
curr_pi = n*obj(y,x,initval);
curr_theta = initval;

b = 2;
iaccept = 0;
scale = 1;
prob = 0;



%% MCMC run
while b<= burnin
    e = randn(4,1);
    propose = curr_theta + cov_chol*e;
    mu = curr_theta;
    prop_pi = n*obj(y,x,propose);
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
    mu = theta(k-1,:)';
    prop_pi = n*obj(y,x,propose);
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

accept = iaccept/keep;