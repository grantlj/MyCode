%�������κ͸��ֽ���Ũ�ȵȸ��ߵ�ͼ��
for i=1:8
    figure;
    [C H]=contour(valAll(:,:,i),'w','ShowText','on');
    clabel(C,H,'FontSize',8);
    hold on;
    mesh((altitude-200)*10000)
    set(gca,'xtick',[],'xticklabel',[])
    set(gca,'ytick',[],'yticklabel',[])
end