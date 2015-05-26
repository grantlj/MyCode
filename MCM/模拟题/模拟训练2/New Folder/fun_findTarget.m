function [ carInfoMat,nodeInfoMat,onRoadMat,markRoadCell ] = fun_findTarget( carInfoMat,nodeInfoMat,onRoadMat,timeMat,markRoadCell )
%为空闲的汽车寻找目标
carNum=size(carInfoMat,2);
for i=1:carNum
    if carInfoMat(1,i)==0
        %开始对i车进行调度
        
        %读出i点的状态
        bikeNum=carInfoMat(2,i);
        nowPos=carInfoMat(3,i);
        
        %求出对点的需求
        minRequire=bikeNum-50;
        maxRequire=bikeNum;
        
        %找到满足需要需要的点
        needNode=(nodeInfoMat(1,:)>=minRequire)&(nodeInfoMat(1,:)<=maxRequire)&(nodeInfoMat(2,:)==1);
        
        %查看是否有满足要求的点
        if sum(needNode,2)>0
            %存在满足要求点，从最近的分配
            time=[  1:size(timeMat,2)  ;timeMat(nowPos,:)];
            time=sortrows(time( :,needNode )',2)';%为了排序  两次转置
            %取排序后的第一个点进行安排    
            targetNode=time(1,1);
            needTime=time(2,1);
            %update nodeInfo
            nodeInfoMat(2,targetNode)=2;
            %updata carInfo
            carInfoMat(1,i)=1;
            %更新onRoad
            go=[i;targetNode;needTime;-nodeInfoMat(1,targetNode)];
            onRoadMat=[onRoadMat,go];
            %从go中导出需要的数据
            %从细胞中取出相应的
            road=markRoadCell{ i };
            road=[road [targetNode ;needTime; -nodeInfoMat(1,targetNode)  ]];
            markRoadCell{ i }=road;
        else
            %不存在满足要求点，缩小条件,找个最近的，而且能运作的地点
            canGO=(nodeInfoMat(2,:)==1);
            if sum(canGO,2)>0
                %存在可以去的点，前往最近的一个
                time=[  1:size(timeMat,2)  ;timeMat(nowPos,:)];
                time=sortrows(time( :,canGO )',2)';%为了排序  两次转置
                 %取排序后的第一个点进行安排    
                targetNode=time(1,1);
                needTime=time(2,1);
                %求解装或卸的数量
                if nodeInfoMat(1,targetNode)>0
                    transportNum=-bikeNum;
                else
                    transportNum=50-bikeNum;
                end
                %update nodeInfo
                nodeInfoMat(2,targetNode)=2;
                %updata carInfo
                carInfoMat(1,i)=1;
                %更新onRoad
                go=[i;targetNode;needTime;transportNum];
                onRoadMat=[onRoadMat,go];
                 %从go中导出需要的数据
                %从细胞中取出相应的
                road=markRoadCell{ i };
                road=[road [targetNode ;needTime;transportNum  ]];   
                markRoadCell{ i }=road;
            end
            
        end
    end
end

end

