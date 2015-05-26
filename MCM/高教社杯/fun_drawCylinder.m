function [] = fun_drawCylinder(r,h)
%r=1;%半径
a=0;%原点x坐标
b=0;%原点y坐标
%h=4;%圆柱高度
m=50;%分割线的条数
[x,y,z]=cylinder(r,m);%创建以(0,0)为圆心，高度为[0,1]，半径为R的圆柱
x=x+a;%平移x轴
y=y+b;%平移y轴，改为(a,b)为底圆的圆心
z=h*z;%高度放大h倍
circle(r,h);
hold on;
h=mesh(x,y,z);%重新绘图
set(h,'EdgeColor','r','FaceColor','r','MarkerEdgecolor','r','MarkerFacecolor','r');
end

function circle(r,h)
x=-r:0.01:r;
y1=sqrt(r^2-x.^2);
y2=-y1;
xVec=[x x((2*r/0.01+1):-1:1)];
yVec=[y1 y2((2*r/0.01+1):-1:1)];
zVec=zeros(size(xVec));
patch(xVec,yVec,zVec,'b');
zVec=h*ones(size(xVec));patch(xVec,yVec,zVec,'b');
end