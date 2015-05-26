function time = fun_countTime( carNum,markRoadCell,timeMat )
%h根据路线计算需要的时间
for i=1:carNum
    %取出路线
    road=markRoadCell{i};    
    t(i)=0;
    for j=1:size(road,2)-1;
        t(i)=t(i)+timeMat(road(1,j),road(1,j+1));        
    end
    t(i)=t(i)+sum( abs(road(3,:)) ,2);
end

time=max(t);

end

