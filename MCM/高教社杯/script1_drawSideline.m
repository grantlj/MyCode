clear
clc

L=120; %模板长度
W=50;    %模板宽度
thick=3;  %木板厚度
H=53;    %桌子高度

width=2.5; %木条宽度
H=H-thick;  %减去厚度的高度

%木条之间需要缝隙，所以就算整除也不行
n=W/width; % n表示木条的数量

if ceil(n)==n
    %n是整数
    n=n-1;
else
    %n是非整数
    n=floor(n);
end

%缝隙长度gap计算
gap=(W-n*width)/(n-1);


%为了简化计算程度，建立对称坐标系
%我们只考虑三维坐标中xyz都大于0的，其他完全可以堆成得到
%这时要考虑n为奇数与偶数的情况
%m表示最外侧木条的下标
if mod(n,2)==0
    %偶数
    m=n/2;
    for i=1:m
       x(i)=(gap+width)*(2*i-1)/2;
    end
else
    %奇数
    m=(n+1)/2;
    for i=1:m
        x(i)=(gap+width)*(i-1);
    end
end

%x对应的y坐标
y=((W/2)^2-x.^2).^0.5;
%每根木条的长度
l=L/2-y;

%最外侧桌角与地面夹角
sita0=asin(H/l(end));

%计算sita角
b=sqrt((l(end)/2*cos(sita0)-( l(end)-l ) ).^2 + ( l(end)/2*sin(sita0) )^2);
c=l(end)-l;
a=l(end)/2;
sita= pi- acos( (b.^2+c.^2-a.^2)./(2.*b.*c));


%最外侧的木条的坐标可以知道，所以计算出的是错误的值，需要修正
xk=x;
yk=y+l.*cos(sita);
zk=l.*sin(sita);
yk(end)=y(end)+l(end)*cos(sita0);
zk(end)=l(end)*sin(sita0);

%画出曲线

%debug
plot(yk,zk);


%由对称性对图像进行扩充
%针对y轴镜像
xk=[xk -xk];x=[x -x];
yk=[yk yk];y=[y y];
zk=[zk zk];

%针对x轴镜像
xk=[xk xk];x=[x x];
yk=[yk -yk];y=[y -y];
zk=[zk zk];

%画出每条桌腿
 for i=1:(size(x,2)) 
     plot3([x(i),xk(i)],[y(i),yk(i)],[0,-zk(i)],'linewidth',8,'color',[rand,rand,rand])    
     hold on
 end
 %画出桌面
hold on
fun_drawCylinder(W/2,thick)


%标出xyz坐标
xlabel('x');
ylabel('y');
zlabel('z');



