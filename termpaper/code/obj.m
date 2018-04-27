function L = obj(y,x,b,tau)

n = length(y);
% L= -1/n*sum((tau-(y<=max(0,x*b))).*(y-max(0,x*b))); % compute tau quantile
check = abs(y-max(0,x*b));
L= -sum(check); % LAD


end