clear

beta = [-6;3;3;3];
n = 5000;
[y x] = dgp(n,beta);

t = -12:0.1:-0.1;
tt = [t;3*ones(3,120)];

L = zeros(12,1);

for i = 1:120
    L(i) = exp(n*obj(y,x,tt(:,i)));
    K(i) = obj(y,x,tt(:,i));
end
plot(t,K)