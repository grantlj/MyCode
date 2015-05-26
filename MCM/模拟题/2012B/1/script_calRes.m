%把六个面（分别是东南西北和向南、向北屋顶）的单位面积上光照瓦数。
clear 
clc
load('data.mat')
anticipateYear=10*1+15*0.9+10*0.8;
%data：东南西北前后
data=[];
data(:,1:4)=originalData(:,2:5);
%求出每个方向的阳光
%求出前面后面的
data(:,5)=round(  (originalData(:,1)*6400+originalData(:,3)*1200)./sqrt(6400^2+1200^2  )  );
data(:,6)=round(  (originalData(:,1)*700+originalData(:,5)*1200)./sqrt(700^2+1200^2 ));

%每面墙的信息（1 2 3 5 6）
originalInfo=[0.9    0.86   0.94   0.86   0.94   0.94;
      0.1598 0.0617 0.1598 0.1598 0.1598 0.1598;
      17.46  11.27  21.34  38.81  9.7    9.7;];
%因为第五面墙壁用了两个逆变器
info=[];
info(:,[1 2 3 4 5])=originalInfo(:,[1 2 3 4 6]);
info(3,4)=originalInfo(3,4)+originalInfo(3,5)*originalInfo(1,5)/originalInfo(1,4);

%两个效率相乘，得到总效率
info(1,:)=info(1,:).*info(2,:);
%第二行变为逆变器最低处理瓦数
info(2,:)=[ 80 30 80 80 80  ];
%三行还是面积
%第四行是每每一块的瓦数，第五行是每瓦单价，地六行是个数，第七行是逆变器的钱
info(4,:)=[ 280 58 280 280 280 ];
info(5,:)=[12.5 4.8 12.5 12.5 12.5];
info(6,:)=[ 9 12 11 25 5 ];
info(7,:)=[ 10200 4500  27600 28900 6900 ];

%把北立面去掉
data(:,4)=[];

%---------分别求每个面的数据----------%
result=[];
for i=1:size(info,2)
    %总花费得出
    price=info(4,i)*info(5,i)*info(6,i)+info(7,i);
    %总功率
    temp=data(:,i);
    sumW=sum( temp(temp>info( 2,i )) )*info( 1,i );
    result(i,1)=anticipateYear*info( 3,i )*sumW/1000;
    result(i,2)=0.5*anticipateYear*info( 3,i )*sumW/1000-price;
    result(i,3)=price/(0.5*info( 3,i )*sumW/1000);
    result(i,4)=price;
end









