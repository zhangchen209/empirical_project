clear, clc;


beta = [-6;3;3;3];
tau = 0.5;
y_c = 0;
d = length(beta);
n = 400;
R = 50;
seed = randseed(133,R);

% generate data
y = zeros(n,R);
x = zeros(n,d,R);
for i=1:R
    [y(:,i) x(:,:,i)] = dgp(n,beta,seed(i));
end
% ols initial value
initval = zeros(4,R);
for i=1:R
    initval(:,i) = (x(:,:,i)'*x(:,:,i))\x(:,:,i)'*y(:,i);
end

%% LTE method
% uniform prior
prmax = [beta(1)+10;beta(2)+10;beta(3)+10;beta(4)+10];
prmin = [beta(1)-10;beta(2)-10;beta(3)-10;beta(4)-10];

% MCMC run
burnin = 10000;
keep = 10000;
r = 1;
theta_1 = zeros(keep,4,R);
accept = zeros(r,1);
theta1_mean = zeros(R,4);
theta_lte = zeros(R,4);
tic
while r<=R
    r
    [theta_1(:,:,r) accept(r)] = mcmc_run(burnin,keep,y(:,r),x(:,:,r), ...
                                      initval(:,r),tau,seed(r));
    theta1_mean(r,:) = mean(theta_1(:,:,r));
    lte_q = @(xi) lte_obj(xi,y(:,r),x(:,:,r),theta_1(:,:,r)');
    theta_lte(r,:) = fminsearch(lte_q,theta1_mean(r,:)');
    r = r+1;
end

elapsed_lte = toc;
% accept = mean(iaccept)/(4*keep);
MSE_lte = var(theta_lte)+(mean(theta_lte)-beta').^2;
RMSE_lte = sqrt(MSE_lte);
MAD_lte = mad(theta_lte);
median_bias_lte = median(theta_lte) - beta';

f1 = figure;
edge = [linspace(beta(1)-3,beta(1)+3,60); ...
    linspace(beta(2)-3,beta(2)+3,60); ...
    linspace(beta(3)-3,beta(3)+3,60); ...
    linspace(beta(4)-3,beta(4)+3,60)];
for i=1:4
    subplot(2,2,i);
    histogram(theta_lte(:,i),edge(i,:));
end


%% Iterative Linear Programming
p = 1;
theta_ilp = zeros(R,4);
localmin = 0;
tic
while p<=R
    p
    [theta_ilp(p,:) lm] = cqr_ilp(x(:,:,p),y(:,p),y_c,tau,initval(:,p));
    localmin = localmin +lm;
    p = p+1;
end

f2 = figure;
for i=1:4
    subplot(2,2,i);
    histogram(theta_ilp(:,i),edge(i,:));
end
elapsed_ilp = toc;
MSE_ilp = var(theta_ilp)+(mean(theta_ilp)-beta').^2;
RMSE_ilp = sqrt(MSE_ilp);
MAD_ilp = mad(theta_ilp);
median_bias_ilp = median(theta_ilp) - beta';

save theta;
    
    
    


