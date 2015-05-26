%画出海拔和各种金属浓度等高线的图像
for i=1:8
    figure;
    [C H]=contour(valAll(:,:,i),'w','ShowText','on');
    clabel(C,H,'FontSize',8);
    hold on;
    mesh((altitude-200)*10000)
    set(gca,'xtick',[],'xticklabel',[])
    set(gca,'ytick',[],'yticklabel',[])
end