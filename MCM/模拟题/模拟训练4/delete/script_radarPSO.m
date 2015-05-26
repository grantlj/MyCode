%-------------带入数据
data=[4650	2560	48469
5150	2985	47620
5150	2135	47538
5650	3410	46770
5650	1710	46605
6150	2135	45754
6150	2985	45837
6650	2560	44901];
%将data换为公里
data=data./1000;

height=1.3;
dHeight=0.3;

%--------------配置参数
tolerance=0.01;                        %允许误差
maxNum=10000000;                    %粒子最大迭代次数
nVars=3;                         %目标函数的自变量个数
particleScale=100;                %粒子群规模
c1=2;                            %每个粒子的个体学习因子，也称为加速常数
c2=2;                            %每个粒子的社会学习因子，也称为加速常数
w=0.6;                           %惯性因子
maxSpeed=0.1;                        %粒子的最大飞翔速度
a=1;                           %约束因子

%-----------初始化
%粒子所在的位置粒子的飞翔速度
[posi,speed]=fun_init(particleScale,maxSpeed,height,dHeight,data);

%求出每点的自适应打度
for i=1:particleScale
    f(i)=fun_obj(posi(i,:),data);
end
%初始化全局最优和局部最优
personalBestPosi=posi;
personalBestFaval=f;

[globalbestFaval,i]=min(personalBestFaval);
globalbestPosi=personalBestPosi(i,:);
%开始迭代
k=1;
while k<maxNum
    if mod(k,10000)==0
        disp(globalbestFaval);
    end
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
    %计算每个点的速度
    for i=1:particleScale 
        speed(i,:)=w*speed(i,:)+c1*rand*(personalBestPosi(i,:)-posi(i,:))+c2*rand*(globalbestPosi-posi(i,:));    
    end
    speed(speed>maxSpeed)=maxSpeed;
    speed(speed<-maxSpeed)=-maxSpeed;
    %更新位置
    posi=posi+speed;
    if abs(globalbestFaval)<tolerance
        break
    end
    k=k+1;

    

end


















