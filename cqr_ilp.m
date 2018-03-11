function [ret locmin] = cqr_ilp(x,y,y_c,tau,initval)

iter_b = 1;
iter_k = 1;
locmin = 0;
burnin = 1000;
keep = 1000;
M = [y,x];
beta = initval;

while iter_b<=burnin
    x_temp = x(x*beta>=y_c,:);
    y_temp = y(x*beta>=y_c);
    M_new = [y_temp, x_temp];
    beta_new = rq(x_temp,y_temp,tau);
    if length(M)==length(M_new)
        if  M~=M_new
            iter_b=iter_b+1;
            beta = beta_new;
            M = M_new;
        else
            ret = beta;
            locmin = 1;
            return
        end
    elseif length(M)~=length(M_new)
        iter_b=iter_b+1;
        beta = beta_new;
        M = M_new;
    else
        ret = beta;
        locmin = 1;
        return;
    end
end

beta_keep = zeros(length(initval),keep);
beta_keep(:,1) = beta;
while iter_k<=burnin
    x_temp = x(x*beta_keep(:,iter_k)>=y_c,:);
    y_temp = y(x*beta_keep(:,iter_k)>=y_c);
    M_new = [y_temp, x_temp];
    beta_new = rq(x_temp,y_temp,tau);
    if length(M)==length(M_new)
        if  M~=M_new
            iter_k=iter_k+1;
            beta_keep(:,iter_k) = beta_new;
            M = M_new;
        else
            ret = beta_keep(:,iter_k);
            locmin = 1;
            return
        end
    elseif length(M)~=length(M_new)
        iter_k=iter_k+1;
        beta_keep(:,iter_k) = beta_new;
        M = M_new;
    else
        ret = beta_keep(:,iter_k);
        locmin = 1;
        return;
    end
end

ret = mean(beta_keep');
        
    