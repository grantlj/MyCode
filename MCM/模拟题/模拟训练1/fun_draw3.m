function fun_draw3( years,val,val2)

for i=1:4
    figure
    plot(years,val(:,i,1),years,val(:,i,2),years,val(:,i,3),years,val(:,i,4),years,val(:,i,5),years,val(:,i,6),years,val(:,i,7),years,val2(:,i));
    xlabel('年份');
    switch i
        case 1 
            ylabel('平均预期寿命');
        case 2 
            ylabel('65岁以上比重');
        case 3 
            ylabel('劳动力供求关系');
        case 4 
            ylabel('国民受教育情况');
    end
    legend('美国','英国','加拿大','德国','爱尔兰','匈牙利','韩国','中国');
end
end

