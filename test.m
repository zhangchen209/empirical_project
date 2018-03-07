clear

beta = [-6;3;3;3];
n = 5000;
seed = randseed(133);

rng(seed);


for i =1:50
    rand
end

% x = randn(n,3);
% x = [ones(n,1) x];
% u = randn(n,1);
% u = x(:,2).^2.*u;
% 
% y_star = x*beta +u;
% 
% y = max(0,y_star);
% Q = obj(y,x,beta)
% 
% p = exp(n*Q)


% t = -12:0.1:-0.1;
% tt = [t;3*ones(3,120)];
% 
% L = zeros(12,1);
% 
% for i = 1:120
%     L(i) = exp(n*obj(y,x,tt(:,i)));
%     K(i) = obj(y,x,tt(:,i));
% end
% plot(t,L)