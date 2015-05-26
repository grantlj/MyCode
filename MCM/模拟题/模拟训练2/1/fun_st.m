function boolean = fun_st( x1,x2,demand,Q)
%约束条件的函数 输入分为：1车路径 2车路径 需求列向量 车的最大容量 自行车点数

boolean=1;
n=size(demand,1);
demand=[demand;0];
%两条路的长度
num(1)=sum(x1>0);
num(2)=sum(x2>0);

%为了循环，补零组合
x=[ x1 zeros(1,n+2-num(1)) ; x2 zeros(1,n+2-num(2))];

for i=1:2
    %车当前的载重
    r=0;
    for j=1:num(i)
        r=r-demand(x(i,j));
        %满足车的条件
        if r<0||r>Q
            boolean=0;
            return;
        end
    end
    %回路的和为0;
    if r~=0
        boolean=0;
        return;
    end
end



end

