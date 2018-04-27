edge = [linspace(beta(1)-1.5,beta(1)+1.5,25); ...
    linspace(beta(2)-0.75,beta(2)+0.75,25); ...
    linspace(beta(3)-0.75,beta(3)+0.75,25); ...
    linspace(beta(4)-0.75,beta(4)+0.75,25)];
nbins = 20;

% MCMC histogram
f1 = figure('Name','Histogram LTE-mean');
for i=1:4
    subplot(1,4,i);
    histogram(lte_mean(:,i),edge(i,:),'Normalization','probability');
end
f2 = figure('Name','Histogram LTE-median');
for i=1:4
    subplot(1,4,i);
    histogram(lte_median(:,i),edge(i,:),'Normalization','probability');
end

% ILP histogram
ed = [linspace(-7.5,0,38); ...
    linspace(0,3.75,38); ...
    linspace(0,3.75,38); ...
    linspace(0,3.75,38)];
f3 = figure('Name','ILP included zeros');
for i=1:4
    subplot(1,4,i);
    histogram(ilp_est(:,i),ed(i,:),'Normalization','probability');
end
f4 = figure('Name','ILP excluded zeros');
for i=1:4
    subplot(1,4,i);
    histogram(ilp_exzero(:,i),edge(i,:),'Normalization','probability');
end