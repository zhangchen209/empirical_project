clear, clc
%% Generate data
N = 1000;
rho = 0;
delta = 2;
beta = ones(9,1);
gamma = beta;
[Y,D,X,Z] = dgp(N,rho,delta,beta,gamma);

tau=[0.25,0.5,0.75]';


%% part (a)
alpha_tilde=zeros(3,1);
m=size(X,2)+1;
b=zeros(m,3);
for i=1:3
    b(:,i) = rq([D+ones(N,1),X], Y, tau(i));
    alpha_tilde(i)=b(end,i);
end

%% part (b)
alpha_hat=zeros(3,1);
for i=1:3
    alpha_hat(i)=a_hat(D,X,Z,Y,tau(i));
end

% %% part (c)
% for i=1:1000
%     [Y,D,X,Z] = dgp(N,rho,delta,beta,gamma);
%     for i=1:3
%     b(:,i) = rq([D+ones(N,1),X], Y, tau(i));
%     a1c(i)=b(end,i);
%     a2c(i)=a_hat(D,X,Z,Y,tau(i));
%     end
% end
% a_tildec=mean(a1c);
% mse1c = mean((a1c-a_tildec)^2);
% a_hatc=mean(a2c);
% mse2c = mean((a2c-a_hatc)^2);
% 
% %% part (d)
% rho=0;
% [Y,D,X,Z] = dgp(N,rho,delta,beta,gamma);
% 
% for i=1:1000
%     [Y,D,X,Z] = dgp(N,rho,delta,beta,gamma);
%     for i=1:3
%     b(:,i) = rq([D+ones(N,1),X], Y, tau(i));
%     a1d(i)=b(end,i);
%     a2d(i)=a_hat(D,X,Z,Y,tau(i));
%     end
% end
% a_tilded=mean(a1d);
% mse1d = mean((a1d-a_tilded)^2);
% a_hatd=mean(a2d);
% mse2d = mean((a2d-a_hatd)^2);
% 
% 
% 
