function [ nodeInfoMat,carInfoMat,loadMat,onRoadMat] = fun_refreshInfo( nodeInfoMat,carInfoMat,loadMat,onRoadMat )
%ʱ�侭����һ����  ˢ��ÿ����  node  car   load  onRoad

   %------------------------ˢ��·�ϱ�

 if size(onRoadMat,2)>0
 
    onRoadMat(3,:)=onRoadMat(3,:)-1;
    judgeOK=onRoadMat(3,:)==0;%�ж��Ƿ�վ
    %ˢ��LoadMat
    targetIndex=deleteZero(judgeOK .* (1:size(judgeOK,2)));
    toLoadMat=onRoadMat( [1 2],targetIndex );
    toLoadMatNum=onRoadMat(4,judgeOK); %ȡ��װ����ж   ��  �ж���
    toLoadMatState=zeros(1,size(toLoadMat,2));
    toLoadMatState(toLoadMatNum>0)=1;
    toLoadMatNum=abs(toLoadMatNum);%�����ֵ �õ�����
    toLoadMat=[toLoadMat;toLoadMatNum;toLoadMatState];
    loadMat=[loadMat ,toLoadMat];

    %��nodeInfo�еĵ���Ϊ����װж
    
    nodeInfoMat(2, deleteZero(judgeOK.*onRoadMat(2,:)) )=3;

    %����carNum  ���Ϊ����װ��
    carInfoMat(1, deleteZero(judgeOK.*onRoadMat(1,:) ))=2;
    carInfoMat(3,deleteZero(judgeOK.*onRoadMat(1,:)))=onRoadMat(2,judgeOK);
    %����onRoad
    onRoadMat(:,judgeOK)=[];
  end

%-----ˢ��װж�������
if size(loadMat,2)>0
    %����ˢ�³��� ����
    %�ж��Ƿ�Ϊװ
    judgeloadInfoState=(loadMat(4,:)==1);
    %װ
    carInfoMat( 2,deleteZero(judgeloadInfoState.*loadMat(1,:)) )= carInfoMat( 2,deleteZero(judgeloadInfoState.*loadMat(1,:) ))+1;
    nodeInfoMat( 1,deleteZero(judgeloadInfoState.*loadMat(2,:)) ) = nodeInfoMat( 1,deleteZero(judgeloadInfoState.*loadMat(2,:)) )+1;
    %ж
    judgeloadInfoState=~judgeloadInfoState;
    carInfoMat( 2,deleteZero(judgeloadInfoState.*loadMat(1,:)) ) =carInfoMat( 2,deleteZero(judgeloadInfoState.*loadMat(1,:)) )-1;
    nodeInfoMat( 1,deleteZero(judgeloadInfoState.*loadMat(2,:)) ) = nodeInfoMat( 1,deleteZero(judgeloadInfoState.*loadMat(2,:)) )-1;

    %ˢ��װж�� ɾȥװж��ɵĵ�
    loadMat(3,:)=loadMat(3,:)-1;
    judgeOK=loadMat(3,:)==0;
    %%targetIndex=deleteZero(judgeOK .* (  ));
    carInfoMat(1,deleteZero(judgeOK.*loadMat(1,:)))=0;%װж��ɺ�ĳ��ĳɿ���
    %װж��ɺ�Ҫ�ͷ�Ŀ��ĵ�
    nodeInfoMat(2,deleteZero(judgeOK.*loadMat(2,:)))=1;
    loadMat(:,judgeOK)=[];%׫д��ɺ��loadMatɾȥ
end





%����node-----------------
nodeInfoMat(2,nodeInfoMat(1,:)==0)=0;









end

