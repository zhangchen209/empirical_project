%% MC chain
hold on
plot(theta_lte(:,4,50))
% for i=1:4
%     subplot(4,1,i)
%     plot(theta_lte((end-999):end,i,50));
% end

figure
[b1,b2] = meshgrid(linspace(2.95,3.05,100),linspace(2.95,3.05,100));

simpost = zeros(100,100);
for i = 1:length(b1)
    for j = 1:length(b2)
        bb = [-6;b1(i,j);b2(i,j);3];
        simpost(i,j) = obj(y(:,50),x(:,:,50),bb,0.5);
    end;
end;
surf(b1,b2,simpost)
xlabel('\theta_2')
ylabel('\theta_3')
zlabel('objective function')
