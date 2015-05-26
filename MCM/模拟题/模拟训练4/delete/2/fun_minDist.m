function [ globalbestFaval ] = fun_minDist( targetLocation,radarInfo)
%FUN_MINDIST Summary of this function goes here
%   Detailed explanation goes here
%代入相关数据，前两个雷达信息在radarInfo中
%syms x y z a b c d e f g;
fy=sym('-(- a^2 + 2*x*a - b^2 + c^2 + d^2 - 2*x*d + e^2 - f^2)/(2*(b - e))');
fz=sym('(- a^4 + 4*a^3*x - 2*a^2*b^2 + 4*a^2*b*e + 2*a^2*c^2 + 2*a^2*d^2 - 4*a^2*d*x - 2*a^2*e^2 - 2*a^2*f^2 - 4*a^2*x^2 + 4*a*b^2*x - 8*a*b*e*x - 4*a*c^2*x - 4*a*d^2*x + 8*a*d*x^2 + 4*a*e^2*x + 4*a*f^2*x - b^4 + 4*b^3*e + 2*b^2*c^2 - 2*b^2*d^2 + 4*b^2*d*x - 6*b^2*e^2 + 2*b^2*f^2 - 4*b^2*x^2 - 4*b*c^2*e + 4*b*d^2*e - 8*b*d*e*x + 4*b*e^3 - 4*b*e*f^2 + 8*b*e*x^2 - c^4 - 2*c^2*d^2 + 4*c^2*d*x + 2*c^2*e^2 + 2*c^2*f^2 - d^4 + 4*d^3*x - 2*d^2*e^2 + 2*d^2*f^2 - 4*d^2*x^2 + 4*d*e^2*x - 4*d*f^2*x - e^4 + 2*e^2*f^2 - 4*e^2*x^2 - f^4)^(1/2)/(2*(b - e))');
%代入数值
fy=subs(fy,{'a','b','c','d','e','f'},{radarInfo(1),radarInfo(2),radarInfo(3),radarInfo(4),radarInfo(5),radarInfo(6)});
fz=subs(fz,{'a','b','c','d','e','f'},{radarInfo(1),radarInfo(2),radarInfo(3),radarInfo(4),radarInfo(5),radarInfo(6)});

fx1=sym('(a*b^2 - a*c^2 - a*d^2 - a^2*d + a*e^2 + b^2*d + b*((a^2 - 2*a*d + b^2 - 2*b*e - c^2 + 2*c*f + d^2 + e^2 - f^2)*(- a^2 + 2*a*d - b^2 + 2*b*e + c^2 + 2*c*f - d^2 - e^2 + f^2))^(1/2) + a*f^2 + c^2*d + d*e^2 - e*((a^2 - 2*a*d + b^2 - 2*b*e - c^2 + 2*c*f + d^2 + e^2 - f^2)*(- a^2 + 2*a*d - b^2 + 2*b*e + c^2 + 2*c*f - d^2 - e^2 + f^2))^(1/2) - d*f^2 + a^3 + d^3 - 2*a*b*e - 2*b*d*e)/(2*(a^2 - 2*a*d + b^2 - 2*b*e + d^2 + e^2))');
fx2=sym('(a*b^2 - a*c^2 - a*d^2 - a^2*d + a*e^2 + b^2*d - b*((a^2 - 2*a*d + b^2 - 2*b*e - c^2 + 2*c*f + d^2 + e^2 - f^2)*(- a^2 + 2*a*d - b^2 + 2*b*e + c^2 + 2*c*f - d^2 - e^2 + f^2))^(1/2) + a*f^2 + c^2*d + d*e^2 + e*((a^2 - 2*a*d + b^2 - 2*b*e - c^2 + 2*c*f + d^2 + e^2 - f^2)*(- a^2 + 2*a*d - b^2 + 2*b*e + c^2 + 2*c*f - d^2 - e^2 + f^2))^(1/2) - d*f^2 + a^3 + d^3 - 2*a*b*e - 2*b*d*e)/(2*(a^2 - 2*a*d + b^2 - 2*b*e + d^2 + e^2))');

x1=subs(fx1,{'a','b','c','d','e','f'},{radarInfo(1),radarInfo(2),radarInfo(3),radarInfo(4),radarInfo(5),radarInfo(6)});
x2=subs(fx2,{'a','b','c','d','e','f'},{radarInfo(1),radarInfo(2),radarInfo(3),radarInfo(4),radarInfo(5),radarInfo(6)});
%求x范围
minX=min(x1,x2);
dX=abs(x1-x2);
%现在需要计算targetLocation到曲线上的最近的点，使用PSO实现

%-----------参数配置
tolerance=1;                        %允许误差
maxNum=100;                    %粒子最大迭代次数
particleScale=40;                %粒子群规模
c1=1;                            %每个粒子的个体学习因子，也称为加速常数
c2=1;                            %每个粒子的社会学习因子，也称为加速常数
w=0.6;                           %惯性因子
maxSpeed=dX*0.15;                        %粒子在三个维度上的最大飞翔速度
%初始化
posi=minX+dX.*rand(particleScale,1);
speed=maxSpeed.*unifrnd(-1,1,[particleScale,1]);

%求出每点的自适应度
for i=1:particleScale
    f(i)=fun_obj(posi(i),targetLocation,fz,fy);
end
%初始化全局最优和局部最优
personalBestPosi=posi;
personalBestFaval=f;
[globalbestFaval,i]=min(personalBestFaval);
globalbestPosi=personalBestPosi(i,:);
%开始迭代
k=1;
while k<maxNum
    disp(k);
    %检测每个粒子的最优
    for i=1:particleScale
        f(i)=fun_obj(posi(i),targetLocation,fz,fy);
        if f(i)<personalBestFaval(i) 
            personalBestFaval(i)=f(i);
            personalBestPosi(i,:)=posi(i,:);            
        end   
    end
    [globalbestFaval,i]=min(personalBestFaval);
    globalbestPosi=personalBestPosi(i,:);
    %计算每个点的速度
    for i=1:particleScale 
        speed(i,:)=w*speed(i,:)+c1*rand*(personalBestPosi(i,:)-posi(i,:))+c2*rand*(globalbestPosi-posi(i,:));    
    end
    speed(speed>maxSpeed)=maxSpeed;
    speed(speed<-maxSpeed)=-maxSpeed;
    posi=posi+speed;
    if globalbestFaval<tolerance
        break
    end
    k=k+1;   
end

end

%目标函数
function value=fun_obj(xVal,targetLocation,fz,fy)
y=subs(fy,{'x'},{xVal});
z=subs(fz,{'x'},{xVal});
value=sum((targetLocation-[xVal y z]).^2,2 );
end
