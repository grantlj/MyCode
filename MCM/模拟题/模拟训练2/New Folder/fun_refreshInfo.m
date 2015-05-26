function [ nodeInfoMat,carInfoMat,loadMat,onRoadMat] = fun_refreshInfo( nodeInfoMat,carInfoMat,loadMat,onRoadMat )
%时间经过了一分钟  刷新每个表  node  car   load  onRoad

   %------------------------刷新路上表

 if size(onRoadMat,2)>0
 
    onRoadMat(3,:)=onRoadMat(3,:)-1;
    judgeOK=onRoadMat(3,:)==0;%判断是否到站
    %刷新LoadMat
    targetIndex=deleteZero(judgeOK .* (1:size(judgeOK,2)));
    toLoadMat=onRoadMat( [1 2],targetIndex );
    toLoadMatNum=onRoadMat(4,judgeOK); %取是装还是卸   和  有多少
    toLoadMatState=zeros(1,size(toLoadMat,2));
    toLoadMatState(toLoadMatNum>0)=1;
    toLoadMatNum=abs(toLoadMatNum);%求绝对值 得到余量
    toLoadMat=[toLoadMat;toLoadMatNum;toLoadMatState];
    loadMat=[loadMat ,toLoadMat];

    %把nodeInfo中的点标记为正在装卸
    
    nodeInfoMat(2, deleteZero(judgeOK.*onRoadMat(2,:)) )=3;

    %更新carNum  标记为正在装载
    carInfoMat(1, deleteZero(judgeOK.*onRoadMat(1,:) ))=2;
    carInfoMat(3,deleteZero(judgeOK.*onRoadMat(1,:)))=onRoadMat(2,judgeOK);
    %更新onRoad
    onRoadMat(:,judgeOK)=[];
  end

%-----刷新装卸相关数据
if size(loadMat,2)>0
    %首先刷新车表 与点表
    %判断是否为装
    judgeloadInfoState=(loadMat(4,:)==1);
    %装
    carInfoMat( 2,deleteZero(judgeloadInfoState.*loadMat(1,:)) )= carInfoMat( 2,deleteZero(judgeloadInfoState.*loadMat(1,:) ))+1;
    nodeInfoMat( 1,deleteZero(judgeloadInfoState.*loadMat(2,:)) ) = nodeInfoMat( 1,deleteZero(judgeloadInfoState.*loadMat(2,:)) )+1;
    %卸
    judgeloadInfoState=~judgeloadInfoState;
    carInfoMat( 2,deleteZero(judgeloadInfoState.*loadMat(1,:)) ) =carInfoMat( 2,deleteZero(judgeloadInfoState.*loadMat(1,:)) )-1;
    nodeInfoMat( 1,deleteZero(judgeloadInfoState.*loadMat(2,:)) ) = nodeInfoMat( 1,deleteZero(judgeloadInfoState.*loadMat(2,:)) )-1;

    %刷新装卸表 删去装卸完成的点
    loadMat(3,:)=loadMat(3,:)-1;
    judgeOK=loadMat(3,:)==0;
    %%targetIndex=deleteZero(judgeOK .* (  ));
    carInfoMat(1,deleteZero(judgeOK.*loadMat(1,:)))=0;%装卸完成后的车改成空闲
    %装卸完成后，要释放目标的点
    nodeInfoMat(2,deleteZero(judgeOK.*loadMat(2,:)))=1;
    loadMat(:,judgeOK)=[];%撰写完成后从loadMat删去
end





%更新node-----------------
nodeInfoMat(2,nodeInfoMat(1,:)==0)=0;









end

