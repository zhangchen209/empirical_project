% t = 0.01:0.01:2;
% k = 1;
% tau = 0.2;
% while k<=200
%     L(k) = obj(y,x,[ones(5,1);t(k);ones(5,1)],tau);
%     Q(k) = exp(N*L(k));
%     k = k+1;
% end
% plot(t,L)
% hold on
% % plot(t,Q)
% oobj = @(b) -obj(y,x,b,tau);
% bb = fminsearch(oobj,2*ones(11,1))
% bq = rq(x, y, tau)
p = 1;
theta_lp = zeros(R,4);
tic
while p<=R
    p
    theta_lp(p,:) = rq(x(:,:,p),y(:,p),0.5);
    p = p+1;
end
elapsed_lp = toc;
MSE_lp = var(theta_lp)+(mean(theta_lp)-beta').^2;
RMSE_lp = sqrt(MSE_lp);
MAD_lp = mad(theta_lp);
median_bias_lp = median(theta_lp) - beta';

for i=1:4
    subplot(2,2,i);
    axis([prmin(i) prmax(i) 0 0.5*R]);
    histogram(theta_lp(:,i),30);
end