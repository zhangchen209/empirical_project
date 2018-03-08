for i=1:4
    subplot(2,2,i);
    axis([prmin(i) prmax(i) 0 0.5*R]);
    histogram(theta_lte(:,i));
end