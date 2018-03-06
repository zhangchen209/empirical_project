clear, clc;



beta = [6;6;6;6];
n = 200;

[y x] = dgp(n,beta);


%% MCMC

B = 5000;
theta = zeros(4,B);
sigma_e = 0.5*eye(4);

post = @(t) exp(n*obj(y,x,t));


for i = 1:B-1
    e = mvnrnd(zeros(4,1),sigma_e)';
    new_theta = theta(:,i) + e;
    mu = theta(:,i);
    sigma = sigma_e;
    rho = post(new_theta)*mvnpdf(new_theta, 3*ones(4,1),eye(4))/ ...
          post(theta(:,i))*mvnpdf(theta(:,i), 3*ones(4,1),eye(4));
    alpha = min(1,rho);
    u = rand;
    theta(:,i+1) = new_theta*(u<alpha) + theta(:,i)*(u>= alpha);
end


    
    
    


