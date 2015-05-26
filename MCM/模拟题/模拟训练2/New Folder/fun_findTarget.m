function [ carInfoMat,nodeInfoMat,onRoadMat,markRoadCell ] = fun_findTarget( carInfoMat,nodeInfoMat,onRoadMat,timeMat,markRoadCell )
%Ϊ���е�����Ѱ��Ŀ��
carNum=size(carInfoMat,2);
for i=1:carNum
    if carInfoMat(1,i)==0
        %��ʼ��i�����е���
        
        %����i���״̬
        bikeNum=carInfoMat(2,i);
        nowPos=carInfoMat(3,i);
        
        %����Ե������
        minRequire=bikeNum-50;
        maxRequire=bikeNum;
        
        %�ҵ�������Ҫ��Ҫ�ĵ�
        needNode=(nodeInfoMat(1,:)>=minRequire)&(nodeInfoMat(1,:)<=maxRequire)&(nodeInfoMat(2,:)==1);
        
        %�鿴�Ƿ�������Ҫ��ĵ�
        if sum(needNode,2)>0
            %��������Ҫ��㣬������ķ���
            time=[  1:size(timeMat,2)  ;timeMat(nowPos,:)];
            time=sortrows(time( :,needNode )',2)';%Ϊ������  ����ת��
            %ȡ�����ĵ�һ������а���    
            targetNode=time(1,1);
            needTime=time(2,1);
            %update nodeInfo
            nodeInfoMat(2,targetNode)=2;
            %updata carInfo
            carInfoMat(1,i)=1;
            %����onRoad
            go=[i;targetNode;needTime;-nodeInfoMat(1,targetNode)];
            onRoadMat=[onRoadMat,go];
            %��go�е�����Ҫ������
            %��ϸ����ȡ����Ӧ��
            road=markRoadCell{ i };
            road=[road [targetNode ;needTime; -nodeInfoMat(1,targetNode)  ]];
            markRoadCell{ i }=road;
        else
            %����������Ҫ��㣬��С����,�Ҹ�����ģ������������ĵص�
            canGO=(nodeInfoMat(2,:)==1);
            if sum(canGO,2)>0
                %���ڿ���ȥ�ĵ㣬ǰ�������һ��
                time=[  1:size(timeMat,2)  ;timeMat(nowPos,:)];
                time=sortrows(time( :,canGO )',2)';%Ϊ������  ����ת��
                 %ȡ�����ĵ�һ������а���    
                targetNode=time(1,1);
                needTime=time(2,1);
                %���װ��ж������
                if nodeInfoMat(1,targetNode)>0
                    transportNum=-bikeNum;
                else
                    transportNum=50-bikeNum;
                end
                %update nodeInfo
                nodeInfoMat(2,targetNode)=2;
                %updata carInfo
                carInfoMat(1,i)=1;
                %����onRoad
                go=[i;targetNode;needTime;transportNum];
                onRoadMat=[onRoadMat,go];
                 %��go�е�����Ҫ������
                %��ϸ����ȡ����Ӧ��
                road=markRoadCell{ i };
                road=[road [targetNode ;needTime;transportNum  ]];   
                markRoadCell{ i }=road;
            end
            
        end
    end
end

end

