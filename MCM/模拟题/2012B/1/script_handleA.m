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
data(:,6)=round(  (originalData(:,1)*700+originalData(:,5)*1200)./sqrt(700^2+1200^2  )  );

%求A的
resA=[];
backA=[];
for i=1:size(a,1)
    %价格
    pri=a(i,1)*price(1);
    %面积
    square=a(i,2)*a(i,3)/1000000;
    %效率
    efficiency=a(i,4);
        
    %因为A有约束，需要大于200
    for j=1:size(data,2)
        temp=data(:,j);
        sum1=sum( temp(temp>=200) );
        sum2=sum( temp(temp<200) );
        resA(i,j)=0.5.*(sum1*efficiency+sum2*efficiency*0.05)./1000.*anticipateYear-pri/square;
        backA(i,j)=pri/square/( 0.5.*(sum1*efficiency+sum2*efficiency*0.05)./1000 );
    end
      
end


%求B
resB=[];
backB=[];
sumMat=sum(data,1);
for i=1:size(b,1)
    %价格
    pri=b(i,1)*price(2);
    %面积
    square=b(i,2)*b(i,3)/1000000;
    %效率
    efficiency=b(i,4);
    resB(i,:)=0.5*(sumMat.*square.*efficiency)./1000.*anticipateYear-pri/square; 
    backB(i,:)=pri/square./( 0.5*(sumMat.*square.*efficiency)./1000 );
    
end

%求C
resC=[];
backC=[];
for i=1:size(c,1)
     %价格
    pri=c(i,1)*price(3);
    %面积
    square=c(i,2)*c(i,3)/1000000;
    %效率
    efficiency=c(i,4);
    
    for j=1:size(data,2)
        temp=data(:,j);
        sum1=sum( temp(temp<=200) );
        sum2=sum( temp(temp>200) );
        resC(i,j)=0.5*(sum1*efficiency*1.01+sum2*efficiency)./1000.*anticipateYear-pri/square;
        backC(i,j)=pri/square/( 0.5*(sum1*efficiency*1.01+sum2*efficiency)./1000 );
    end
    
end

