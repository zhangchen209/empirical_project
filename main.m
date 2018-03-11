clear, clc;


beta = [-6;3;3;3];
tau = 0.5;
y_c = 0;
d = length(beta);
n = 1600;
R = 100;
seed = randseed(1333,R);
% edge = [linspace(beta(1)-1.5,beta(1)+1.5,60); ...
%     linspace(beta(2)-1.5,beta(2)+1.5,30); ...
%     linspace(beta(3)-1.5,beta(3)+1.5,30); ...
%     linspace(beta(4)-1.5,beta(4)+1.5,30)];
nbins = 35;


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
prmax = beta+10;
prmin = beta-10;

% MCMC run
burnin_lte = 10000;
keep_lte = 10000;
accrate = 0.3;
r_lte = 1;
theta_lte = zeros(keep_lte,4,R);
accept = zeros(r_lte,4);
lte_median = zeros(R,4);
lte_mean = zeros(R,4);

while r_lte<=R
    r_lte
    theta_lte(:,:,r_lte) = mcmc_run(y(:,r_lte),x(:,:,r_lte),initval(:,r_lte), ...
                                      tau,burnin_lte,keep_lte,accrate,seed(r_lte));
    lte_mean(r_lte,:) = mean(theta_lte(:,:,r_lte));
    lte_median(r_lte,:) = median(theta_lte(:,:,r_lte));
    % lte_q = @(xi) -lte_obj(xi,y(:,r),x(:,:,r),theta(:,:,r)');
    % theta_lte(r,:) = neldmead(lte_q,theta1_mean(r,:)');
    r_lte = r_lte+1;
end

% accept = mean(iaccept)/(4*keep);
% lte_mean --------------------------------------------
MSE_lte_mean = var(lte_mean)+(mean(lte_mean)-beta').^2;
RMSE_lte_mean = sqrt(MSE_lte_mean);
MAD_lte_mean = mad(lte_mean);
mbias_lte_mean = median(lte_mean) - beta';
% lte_median ------------------------------------------
MSE_lte_median = var(lte_median)+(mean(lte_median)-beta').^2;
RMSE_lte_median = sqrt(MSE_lte_median);
MAD_lte_median = mad(lte_median);
mbias_lte_median = median(lte_median) - beta';
% -----------------------------------------------------

f1 = figure('Name','Histogram LTE-mean');
for i=1:4
    subplot(2,2,i);
    histogram(lte_mean(:,i),nbins);
end
f2 = figure('Name','Histogram LTE-median');
for i=1:4
    subplot(2,2,i);
    histogram(lte_median(:,i),nbins);
end


%% Iterative Linear Programming
r_ilp = 1;
burnin_ilp = 1000;
keep_ilp = 1000;
theta_ilp = zeros(keep_ilp,4,R);
localmin = 0; % count the times localmin been found
out = 0; % count times converge to a localmin of zero

while r_ilp<=R
    r_ilp
    [ret theta_ilp(:,:,r_ilp) lm] = cqr_ilp(x(:,:,r_ilp),y(:,r_ilp),y_c,tau,initval(:,r_ilp), ...
                                burnin_ilp,keep_ilp);
    if norm(ret)==0
        out = out +1;
    end
    ilp_est(r_ilp,:) = ret';
    localmin = localmin +lm;
    r_ilp = r_ilp+1;
end
ilp_exzero = ilp_est(ilp_est(:,2)~=0,:);

f3 = figure('Name','ILP included zeros');
for i=1:4
    subplot(2,2,i);
    histogram(ilp_est(:,i),nbins);
end
f4 = figure('Name','ILP excluded zeros');
for i=1:4
    subplot(2,2,i);
    histogram(ilp_exzero(:,i),nbins);
end

% ilp estimates excluded local convergence to 0 -------------
MSE_ilp_all = var(ilp_est)+(mean(ilp_est)-beta').^2;
RMSE_ilp_all = sqrt(MSE_ilp_all);
MAD_ilp_all = mad(ilp_est);
mbias_ilp_all = median(ilp_est) - beta';
% ilp estimates excluded local convergence to 0 -------------
MSE_ilp_exzero = var(ilp_exzero)+(mean(ilp_exzero)-beta').^2;
RMSE_ilp_exzero = sqrt(MSE_ilp_exzero);
MAD_ilp_exzero = mad(ilp_exzero);
mbias_ilp_exzero = median(ilp_exzero) - beta';
% -----------------------------------------------------------

save sample_1600;
    
    
    


