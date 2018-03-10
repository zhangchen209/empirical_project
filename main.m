clear, clc;


beta = [-6;3;3;3];
tau = 0.3;
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


%% LTE method
% prior
prmax = [4;13;13;13];
prmin = [-16;-7;-7;-7];

% MCMC run
burnin = 10000;
keep = 10000;
r = 1;
theta_1 = zeros(keep,4,R);
iaccept = zeros(r,1);
theta1_mean = zeros(R,4);
theta_lte = zeros(R,4);
tic
while r<=R
    r
    initval = (x(:,:,r)'*x(:,:,r))\x(:,:,r)'*y(:,r);
    [theta_1(:,:,r) iaccept(r)] = mcmc_run(burnin,keep,y(:,r),x(:,:,r),initval, ...
                                      tau,seed(r));
    theta1_mean(r,:) = mean(theta_1(:,:,r));
    lte_q = @(xi) lte_obj(xi,y(:,r),x(:,:,r),theta_1(:,:,r)');
    theta_lte(r,:) = fminsearch(lte_q,theta1_mean(r,:)');
    r = r+1;
end

elapsed_lte = toc;
accept = iaccept/keep;
MSE_lte = var(theta_lte)+(mean(theta_lte)-beta').^2;
RMSE_lte = sqrt(MSE_lte);
MAD_lte = mad(theta_lte);
median_bias_rq = median(theta_lte) - beta';


for i=1:4
    subplot(2,2,i);
    axis([prmin(i) prmax(i) 0 0.5*R]);
    histogram(theta_lte(:,i),50);
end


%% Linear Programming
p = 1;
theta_lp = zeros(R,4);
tic
while p<=R
    p
    theta_lp(p,:) = rq(x(:,:,p),y(:,p),tau);
    p = p+1;
end
elapsed_lp = toc;
MSE_lp = var(theta_lp)+(mean(theta_lp)-beta').^2;
RMSE_lp = sqrt(MSE_lp);
MAD_lp = mad(theta_lp);
median_bias_lp = median(theta_lp) - beta';

save theta;
    
    
    


