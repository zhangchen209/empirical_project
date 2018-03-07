clear, clc;


beta = [-6;3;3;3];
n = 400;
seed = randseed(133);

[y x] = dgp(n,beta,seed);

%% prior
prmax = [4;13;13;13];
prmin = [-16;-7;-7;-7];




%% Initialize MCMC
T = 5000;
theta = zeros(4,T);
theta(:,1) = (x'*x)\x'*y;
ehat = y - x*theta(:,1);
sig  = mean(ehat.^2);
promu = zeros(4,1);
prosig = eye(4);
prosig = chol(prosig);
cov = sig^2*(x'*x)^(-1);
cov_chol = chol(cov)';

post = @(t) n*obj(y,x,t); % + sum(log(unifpdf(t,prmin,prmax)));
curr_pi = post(theta(:,1));
t = 2;
iaccept = 0;
scale = 1;
prob = 0;

%% MCMC run
while t<= T
    t
    e = randn(4,1);
    propose = theta(:,t-1) + cov_chol*e;
    mu = theta(:,t-1);
    prop_pi = post(propose);
    if prop_pi == NaN;
        prop_pi = -1000000;
    end
    u = unifrnd(0,1);
    prob = [prob; exp(prop_pi - curr_pi)];
    if u < exp(prop_pi - curr_pi); iaccept = iaccept + 1;
        theta(:,t) = propose;
        curr_pi = prop_pi;
    else theta(:,t) = theta(:,t-1);
    end
    
    t = t+1;
end
save theta;

    
    
    


