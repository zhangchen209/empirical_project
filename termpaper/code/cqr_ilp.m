function [ret,ilp_simul,locmin] = cqr_ilp(x,y,y_c,tau,initval,burnin,keep)

iter_b = 1;
iter_k = 1;
locmin = 0;

M = [y,x];
beta = initval;
ilp_simul = zeros(keep,length(initval));

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
while iter_k<=keep
    x_temp = x(x*beta_keep(:,iter_k)>=y_c,:);
    y_temp = y(x*beta_keep(:,iter_k)>=y_c);
    M_new = [y_temp, x_temp];
    beta_new = rq(x_temp,y_temp,tau);
    if length(M)==length(M_new)
        if  M~=M_new
            beta_keep(:,iter_k) = beta_new;
            iter_k=iter_k+1;
            M = M_new;
        else
            ret = beta_keep(:,iter_k);
            locmin = 1;
            return
        end
    elseif length(M)~=length(M_new)
        beta_keep(:,iter_k) = beta_new;
        iter_k=iter_k+1;
        M = M_new;
    else
        ret = beta_keep(:,iter_k);
        locmin = 1;
        return;
    end
end
ret = beta_new;
ilp_simul = beta_keep';

end
    