function [ H ] = fun_AOM( val3, bgval)
% 由xyz与相对应的值和背景值
%求AOM区域中的点和其对应的值并且画出图像
save=val3;
re=[];
%循环查找正好的Igeo值
for i=6:-0.05:0.05
    tempval= log( val3(:,3)./(bgval.*1.5)  )./log(2);
    is=(tempval>i);
    if 4<=sum(is)&&sum(is)<=6
        re=is;
        break;
    end
end
%防止出现没有在规定个数
if 4>sum(re)||sum(re)>6
    disp('error');
end
%保留AOM
sumre=sum(re);
re=~re;
re=[re re re];
val3(re)=[];
val=reshape(val3,sumre,length(val3)./sumre);

%计算AOM必要的值
Igeo=log( val(:,3)./(bgval.*1.5)  )./log(2);
Igeo(Igeo<=0)=0;
Igeo=ceil(Igeo);
Igeo(Igeo>=6)=6;
val(:,4)=Igeo;

%求每个点的半径
for i=1:sumre
    val(i,5)=0;
    for j=1:sumre
        
        if j==i
            continue
        end
        val(i,5)=val(i,5)+val(j,4).*sqrt( (val(i,1)-val(j,1))^2 + (val(i,2)-val(j,2))^2 );
                
    end
end

 val(:,5)=val(:,5)./(sum(Igeo)-1);
%开始画图--
%打点plot
plot(save(:,1),save(:,2),'go');
%画圆
for i=1:sumre
    hold on
    fun_circle(val(i,1) , val(i,2) , val(i,5) );   
end
hold on
plot(val(:,1) , val(:,2),'r*');
axis([0 30000 0 20000])
%返回值
H=val;
end

function  fun_circle(x,y,R)
%画圆
%用于画圆的子函数
alpha=0:pi/50:2*pi;
X=x+R*cos(alpha); 
Y=y+R*sin(alpha); 
plot(X,Y,'b-') 

end



