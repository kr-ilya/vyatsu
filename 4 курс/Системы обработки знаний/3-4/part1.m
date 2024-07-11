plot(penguins(:, 2), penguins(:,2),'.r','MarkerSize',20)
hold on

net = selforgmap([6,6]);
net = train(net,penguins');

W = net.iw{1,1}
length(W)
for i = 1:length(W)
	text(W(i,1),W(i,2),int2str(i),'HorizontalAlignment','center', 'VerticalAlignment', 'bottom')
end
hold on
plotsom(net.iw{1,1},net.layers{1}.distances)
plot(TestData(:,1),TestData(:,2),'.g','MarkerSize',20)
set(gca, 'DataAspectRatio', [1, 200, 1])

hold off
plotsomhits(net, penguins')
plotsomhits(net, TestData')