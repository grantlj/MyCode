%画出区域和各种金属浓度等高线的图像
for i=1:8
    figure;
    [C H]=contour(Xq,Yq,valAll(:,:,i),17,'k');
    clabel(C,H,'FontSize',8);[C H]=contourf(Xq,Yq,valAll(:,:,i),8,'w','ShowText','on');
    hold on;
    mesh((use1-5).*100000-1)
    set(gca,'xtick',[],'xticklabel',[])
    set(gca,'ytick',[],'yticklabel',[])
end