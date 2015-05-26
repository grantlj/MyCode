%丙飞机的信息
data=[7335	1370	107160
8705	1370	106150
7335	2170	106450
8705	2170	105440
7335	2970	105730
8705	2970	104720
7335	3770	105000
8705	3770	103990
7335	4570	104250
8705	4570	103240
7335	5370	103480
8705	5370	102480];

mark=[];
for i=1:(size(data,1)-2)
    for j=(i+1):(size(data,1)-1)
        if fun_isIntersect(data(i,:),data(j,:))
            for k=(j+1):size(data,1)
                if data(i,1)~=data(j,1)&&data(i,2)~=data(j,2)
                    [minDist,posi]=fun_minDist2(data(k,:),[data(i,:),data(j,:)]);
                    mark=[mark;[data(i,:),data(j,:),minDist,posi]];
                end
            end
        end
    end
end



