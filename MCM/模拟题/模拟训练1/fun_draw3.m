function fun_draw3( years,val,val2)

for i=1:4
    figure
    plot(years,val(:,i,1),years,val(:,i,2),years,val(:,i,3),years,val(:,i,4),years,val(:,i,5),years,val(:,i,6),years,val(:,i,7),years,val2(:,i));
    xlabel('���');
    switch i
        case 1 
            ylabel('ƽ��Ԥ������');
        case 2 
            ylabel('65�����ϱ���');
        case 3 
            ylabel('�Ͷ��������ϵ');
        case 4 
            ylabel('�����ܽ������');
    end
    legend('����','Ӣ��','���ô�','�¹�','������','������','����','�й�');
end
end

