%�������棨�ֱ��Ƕ������������ϡ����ݶ����ĵ�λ����Ϲ���������
clear 
clc
load('data.mat')
anticipateYear=10*1+15*0.9+10*0.8;
%data����������ǰ��
data=[];
data(:,1:4)=originalData(:,2:5);
%���ÿ�����������
%���ǰ������
data(:,5)=round(  (originalData(:,1)*6400+originalData(:,3)*1200)./sqrt(6400^2+1200^2  )  );
data(:,6)=round(  (originalData(:,1)*700+originalData(:,5)*1200)./sqrt(700^2+1200^2 ));

%ÿ��ǽ����Ϣ��1 2 3 5 6��
originalInfo=[0.9    0.86   0.94   0.86   0.94   0.94;
      0.1598 0.0617 0.1598 0.1598 0.1598 0.1598;
      17.46  11.27  21.34  38.81  9.7    9.7;];
%��Ϊ������ǽ���������������
info=[];
info(:,[1 2 3 4 5])=originalInfo(:,[1 2 3 4 6]);
info(3,4)=originalInfo(3,4)+originalInfo(3,5)*originalInfo(1,5)/originalInfo(1,4);

%����Ч����ˣ��õ���Ч��
info(1,:)=info(1,:).*info(2,:);
%�ڶ��б�Ϊ�������ʹ�������
info(2,:)=[ 80 30 80 80 80  ];
%���л������
%��������ÿÿһ�����������������ÿ�ߵ��ۣ��������Ǹ��������������������Ǯ
info(4,:)=[ 280 58 280 280 280 ];
info(5,:)=[12.5 4.8 12.5 12.5 12.5];
info(6,:)=[ 9 12 11 25 5 ];
info(7,:)=[ 10200 4500  27600 28900 6900 ];

%�ѱ�����ȥ��
data(:,4)=[];

%---------�ֱ���ÿ���������----------%
result=[];
for i=1:size(info,2)
    %�ܻ��ѵó�
    price=info(4,i)*info(5,i)*info(6,i)+info(7,i);
    %�ܹ���
    temp=data(:,i);
    sumW=sum( temp(temp>info( 2,i )) )*info( 1,i );
    result(i,1)=anticipateYear*info( 3,i )*sumW/1000;
    result(i,2)=0.5*anticipateYear*info( 3,i )*sumW/1000-price;
    result(i,3)=price/(0.5*info( 3,i )*sumW/1000);
    result(i,4)=price;
end









