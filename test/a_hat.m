function alpha=a_hat(D,X,Z,Y,tau)

a_max = 2;
a_min = 0;
h = 0.01;
grid = a_min:h:a_max;
grid = grid';
b = zeros(size(X,2)+size(Z,2),length(grid));
f = zeros(length(grid),1);
norm = 9999;
k = 0;
for i=1:length(grid)
    yy = Y - D*grid(i);
    b(:,i) = rq([X,Z],yy,tau);
    gamma_hat(:,i) = b(end,i);
    norm_gamma = sqrt(sum(gamma_hat(:,i).^2));
    if norm>=norm_gamma
        norm=norm_gamma;
        k=i;
    end
end
beta = b(:,i);
alpha = grid(k);
