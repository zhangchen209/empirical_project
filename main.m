clear, clc;


beta = [-6;3;3;3];
n = 400;
R = 500;
seed = randseed(133,R);


%% prior
prmax = [4;13;13;13];
prmin = [-16;-7;-7;-7];

%% MCMC run
burnin = 10000;
keep = 10000;
r = 1;
theta = zeros(keep,4,R);
iaccept = zeros(r,1);
theta_mean = zeros(R,4);
theta_lte = zeros(R,4);
tic
while r<=R
    r
    [y x] = dgp(n,beta,seed(r));
    initval = (x'*x)\x'*y;
    [theta(:,:,r) iaccept(r)] = mcmc_run(burnin,keep,y,x,initval, ...
                                      seed(r));
    theta_mean(r,:) = mean(theta(:,:,r));
    lte_q = @(xi) lte_obj(xi,y,x,theta(:,:,r)');
    theta_lte(r,:) = fminsearch(lte_q,theta_mean(r,:)');
    r = r+1;
end
elapsed_lte = toc;

accept = iaccept/keep;



for i=1:4
    subplot(2,2,i);
    axis([prmin(i) prmax(i) 0 0.5*R]);
    histogram(theta_lte(:,i));
end
save theta;
    
    
    


