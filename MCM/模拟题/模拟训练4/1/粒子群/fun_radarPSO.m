function [process,posi] = fun_radarPSO( data )
%FUN_RADARPSO Summary of this function goes here
%记录过程
process=[];
%--------------配置参数
tolerance=200;           %允许误差
maxNum=10000;                    %粒子最大迭代次数
%nVars=3;                         %目标函数的自变量个数
particleScale=200;                %粒子群规模
c1=2;                            %每个粒子的个体学习因子，也称为加速常数
c2=2;                            %每个粒子的社会学习因子，也称为加速常数
w=0.8;                           %惯性因子
maxSpeed=2000;                        %粒子在三个维度上的最大飞翔速度
a=1;                           %约束因子

%-----------初始化
%粒子所在的位置粒子的飞翔速度
[posi,speed]=fun_init(particleScale,maxSpeed,data);

%求出每点的自适应打度
for i=1:particleScale
    f(i)=fun_obj(posi(i,:),data);
end
%初始化全局最优和局部最优
personalBestPosi=posi;
personalBestFaval=f;

[globalbestFaval,i]=min(personalBestFaval);
globalbestPosi=personalBestPosi(i,:);
process=[process;[globalbestFaval,globalbestPosi]];
%开始迭代
k=1;
while k<maxNum
    
    
    %检测每个粒子的最优
    for i=1:particleScale
        f(i)=fun_obj(posi(i,:),data);
        %判断当前位置是否是历史上最佳位置
        if f(i)<personalBestFaval(i) 
            personalBestFaval(i)=f(i);
            personalBestPosi(i,:)=posi(i,:);
            
        end        
    end
    %检测全局最优
    [globalbestFaval,i]=min(personalBestFaval);
    globalbestPosi=personalBestPosi(i,:);
    if mod(k,100)==0
        %process=[process;[globalbestFaval,globalbestPosi]];
        disp(k);
        disp(globalbestFaval);
        disp(globalbestPosi);
    end
    process=[process;[globalbestFaval,globalbestPosi]];
    
    %计算每个点的速度
    for i=1:particleScale 
        speed(i,:)=w*speed(i,:)+c1*rand*(personalBestPosi(i,:)-posi(i,:))+c2*rand*(globalbestPosi-posi(i,:));    
    end
    speed(speed>maxSpeed)=maxSpeed;
    speed(speed<-maxSpeed)=-maxSpeed;
    %更新位置
    posi=posi+speed;
    if globalbestFaval<tolerance
        break
    end
    k=k+1; 
%     %画图
%     if k==2
%         plot3(posi(:,1),posi(:,2),posi(:,3),'y*');
%         hold on
%         pause(1);
%     elseif k==300
%         plot3(posi(:,1),posi(:,2),posi(:,3),'g*');
%         hold on
%         pause(1);
%     elseif k==600
%         plot3(posi(:,1),posi(:,2),posi(:,3),'b*');
%         hold on
%         pause(1);
%     elseif k==1000
%         plot3(posi(:,1),posi(:,2),posi(:,3),'r*');
%         hold on
%         pause(1);
%     end
end

end

function boolean=fun_st(posi,data)

eVec=((data(:,1)-posi(1)).^2+(data(:,2)-posi(2)).^2+posi(3).^2).^0.5-data(:,3);
if sum(abs(eVec)<=50)>0
    boolean=1;
else
    boolean=0;
end
end

function [ posi,speed ] = fun_init( particleScale,maxSpeed,data )
%初始化粒子群的位置和速度
posi=[];
speed=[];
%-------初始化位置

for i=1: particleScale
    newPosi=[mean(data(:,1)) mean(data(:,2)) 0];
    fayi=pi*unifrnd(0.01,0.5);
    sita=pi*unifrnd(-1,1);
    dz=100*sin(fayi);
    dx=100*cos(fayi)*cos(sita);
    dy=100*cos(fayi)*sin(sita);
    d=[dx dy dz];
    
    while fun_st(newPosi,data)==0
        newPosi=newPosi+d;
    end
    posi=[posi;newPosi];
end


%-------初始化速度
speed=unifrnd(-1,1,[particleScale,3]).*maxSpeed;

end

function obj = fun_obj( posi,data )
%计算内能的函数
eVec=((data(:,1)-posi(1)).^2+(data(:,2)-posi(2)).^2+posi(3).^2).^0.5-data(:,3);
obj=sum(abs(eVec));
end
