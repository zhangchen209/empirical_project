function Q = lte_obj(xi,y,x,hist)

n = length(y);
rho = sqrt(n)*sum(abs(x*(hist-xi)-y));
Q = sum(rho);

end
