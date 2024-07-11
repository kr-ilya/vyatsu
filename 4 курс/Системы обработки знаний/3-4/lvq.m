net = selforgmap([3,2]);
net = train(net,penguins');

W = net.iw{1,1}
length(W)
for i = 1:length(W)
	text(W(i,1),W(i,2),int2str(i),'HorizontalAlignment','center', 'VerticalAlignment', 'bottom')
end
hold on
plot(penguins(:, 1), penguins(:,2),'.g','MarkerSize',10)
plotsom(net.iw{1,1},net.layers{1}.distances)



tpenguins = penguins';
T = [];
for i = 1:length(tpenguins)
	y = net([tpenguins(1, i); tpenguins(2, i)]);
	cluster_index = vec2ind(y);
	T = [T cluster_index];
end
colors = ['r', 'b','g', 'c', 'm', 'y'];
figure(1), clf, axis([min(tpenguins(1,:))-5,max(tpenguins(1,:))+5,min(tpenguins(2,:))-5,max(tpenguins(2,:)+5)]), hold on  
for i = 1:6
	tmp = find(T==i);
	s = num2str(i) + 'r';
	text(tpenguins(1,tmp),tpenguins(2,tmp), num2str(i),'Color',colors(i), 'FontSize', 6);
	hold on
end


t = ind2vec(T);
lnet = lvqnet(8,0.2,'learnlv2');
lnet.trainParam.epochs=150;
lnet=train(lnet,tpenguins,t);


lnet.IW{1}

plotvec(lnet.IW{1}',vec2ind(lnet.LW{2}),'o');
set(gca, 'DataAspectRatio', [1, 200, 1])

cl = vec2ind(lnet([50.4, 5750]'));
cl = vec2ind(lnet([45.2, 5200]'));
cl = vec2ind(lnet([51.5, 5500]'));
