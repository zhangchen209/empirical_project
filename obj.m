function L = obj(y,x,b)

n = length(y);
L= -1/n*sum(abs(y-max(0,x*b)));


end