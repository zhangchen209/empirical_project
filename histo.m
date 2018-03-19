% MCMC histogram
f1 = figure('Name','Histogram LTE-mean');
for i=1:4
    subplot(2,2,i);
    axis([beta(i)-1 beta(i)+1],[0 R/2])
    histogram(lte_mean(:,i),nbins);
end
f2 = figure('Name','Histogram LTE-median');
for i=1:4
    subplot(2,2,i);
    histogram(lte_median(:,i),nbins);
end

% ILP histogram
f3 = figure('Name','ILP included zeros');
for i=1:4
    subplot(2,2,i);
    histogram(ilp_est(:,i),nbins);
end
f4 = figure('Name','ILP excluded zeros');
for i=1:4
    subplot(2,2,i);
    histogram(ilp_exzero(:,i),nbins);
end