function [] = fun_drawCylinder(r,h)
%r=1;%�뾶
a=0;%ԭ��x����
b=0;%ԭ��y����
%h=4;%Բ���߶�
m=50;%�ָ��ߵ�����
[x,y,z]=cylinder(r,m);%������(0,0)ΪԲ�ģ��߶�Ϊ[0,1]���뾶ΪR��Բ��
x=x+a;%ƽ��x��
y=y+b;%ƽ��y�ᣬ��Ϊ(a,b)Ϊ��Բ��Բ��
z=h*z;%�߶ȷŴ�h��
circle(r,h);
hold on;
h=mesh(x,y,z);%���»�ͼ
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