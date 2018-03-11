function [theta accept] = mcmc_run(burnin,keep,y,x,initval,tau,seed)

rng(seed);
theta = zeros(keep,4);
ehat = y - x*initval;
n = length(y);
promu = zeros(4,1);
prosig = eye(4);
prosig = chol(prosig);
ehat_sq  = mean(ehat.^2);
scale = 1;
% cov = scale*ehat_sq^2*(x'*x)^(-1);
% cov_chol = chol(cov)';

% post = @(t) n*obj(y,x,t); %+ sum(log(unifpdf(t,prmin,prmax)));
curr_pi = n*obj(y,x,initval,tau);
curr_theta = initval;
propose = curr_theta;
b = 2;
accept = 0;


%% MCMC run
adjust = accept;
while b<= burnin
    if mod(b,100)==0
        scale = scale*(1+(accept-adjust)/100-0.5);
        adjust = accept;
    end
    e = randn(4,1);
    e = scale*e;
    
    for i = 1:4
        propose(i) = curr_theta(i) + e(i);
        prop_pi = n*obj(y,x,propose,tau);
        if prop_pi == NaN;
            prop_pi = -1000000;
        end
        u = unifrnd(0,1);
        u = log(u);
        if u < prop_pi - curr_pi;
            curr_theta = propose;
            curr_pi = prop_pi;
            accept = accept+1;
        end
    end
    
    b = b+1;
end

theta(1,:) = curr_theta';
k = 2;
while k<= keep
    if mod(k,100)==0
        scale = scale*(1+(accept-adjust)/100-0.5);
        adjust = accept;
    end
    e = randn(4,1);
    e = scale*e;
    for i=1:4
        propose(i) = curr_theta(i)' + e(i);
        prop_pi = n*obj(y,x,propose,tau);
        if prop_pi == NaN;
            prop_pi = -999999;
        end
        u = unifrnd(0,1);
        u = log(u);
        if u < prop_pi - curr_pi;
            accept = accept + 1;
            curr_theta = propose;
            curr_pi = prop_pi;
        end
    end
    theta(k,:) = curr_theta';
    
    k = k+1;
end


end