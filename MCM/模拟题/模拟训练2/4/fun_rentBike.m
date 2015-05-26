function onRoadMat = fun_rentBike( probabMat,bikeTimeMat,avg1min )
%生成1分钟的租车情况

n=size(avg1min,1);
rent=rand(n,1)<avg1min;
onRoadMat=[];
for i=1:n
    if rent(i)==1
        temp=probabMat(i,:);
        index=1:n;
        iszero=(temp==0);
        index(iszero)=[];
        temp(iszero)=[];
        num=size(temp,2);
        temprnd=rand;
        flag=num;
        for j=num-1:-1:1
            if temprnd>sum(temp(1:j),2)
                flag=j+1;
                break;
            elseif j==1
                flag=1;
            end
        end
        onRoadMat=[onRoadMat,[ i;index(flag); bikeTimeMat(i,index(flag))]];
    end
end




end

