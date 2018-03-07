clear, clc;



beta = [-6;3;3;3];
n = 400;

[y x] = dgp(n,beta);


%% MCMC

B = 10000;
theta = zeros(4,B);
theta(:,1) = (x'*x)\x'*y;
sigma_e = 0.5*eye(4);

post = @(t) exp(n*obj(y,x,t));


for i = 1:B-1
    e = mvnrnd(zeros(4,1),sigma_e)';
    new_theta = theta(:,i) + e;
    mu = theta(:,i);
    sigma = sigma_e;
    rho = post(new_theta)/ ...
          post(theta(:,i));
    alpha = min(1,rho);
    u = rand;
    theta(:,i+1) = new_theta*(u<alpha) + theta(:,i)*(u>= alpha);
end


    
    
    


