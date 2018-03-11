function [theta accept] = mcmc_run(y,x,initval,tau,burnin,keep,acc_rate,seed)

rng(seed);
theta = zeros(keep,4);
ehat = y - x*initval;
n = length(y);
promu = zeros(4,1);
prosig = eye(4);
prosig = chol(prosig);
ehat_sq  = mean(ehat.^2);
scale = ones(4,1);
% cov = scale*ehat_sq^2*(x'*x)^(-1);
% cov_chol = chol(cov)';

% post = @(t) obj(y,x,t); %+ sum(log(unifpdf(t,prmin,prmax)));
curr_pi = obj(y,x,initval,tau); % posterior kernel Ln(theta)
curr_theta = initval;
propose = curr_theta;
b = 2;
accept = zeros(4,1);
adjust = accept;

%% MCMC run

while b<= burnin
    if mod(b,100)==0
        for i=1:4
            scale(i) = scale(i)*(1+(accept(i)-adjust(i))/100-acc_rate);
            adjust(i) = accept(i);
        end
    end
    e = randn(4,1);
    e = scale.*e;
    
    for i = 1:4
        propose(i) = curr_theta(i) + e(i);
        prop_pi = obj(y,x,propose,tau);
        if prop_pi == NaN;
            prop_pi = -1000000;
        end
        u = unifrnd(0,1);
        u = log(u);
        if u < prop_pi - curr_pi;
            curr_theta = propose;
            curr_pi = prop_pi;
            accept(i) = accept(i)+1;
        end
    end
    
    b = b+1;
end

theta(1,:) = curr_theta';
k = 2;
while k<= keep
    if mod(k,100)==0
        scale(i) = scale(i)*(1+(accept(i)-adjust(i))/100-acc_rate);
        adjust(i) = accept(i);
    end
    e = randn(4,1);
    e = scale(i)*e;
    for i=1:4
        propose(i) = curr_theta(i)' + e(i);
        prop_pi = obj(y,x,propose,tau);
        if prop_pi == NaN;
            prop_pi = -999999;
        end
        u = unifrnd(0,1);
        u = log(u);
        if u < prop_pi - curr_pi;
            accept(i) = accept(i) + 1;
            curr_theta = propose;
            curr_pi = prop_pi;
        end
    end
    theta(k,:) = curr_theta';
    
    k = k+1;
end
accept = accept';

end