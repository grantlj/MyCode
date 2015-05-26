clc
clear
x23=sqrt(50366.7^2+13107.2^2);
x2=50366.7;
z2=13107.2;
t0=0;tf=50;
[t,y]=ode45('fun_eq2',[t0,tf],[0 0]);

while abs(y(end,1)-x23)>10
    tf=tf+1;
    [t,y]=ode45('fun_eq2',[t0,tf],[0 0]);
end

xv=y(:,1).*x2./x23;
yv=y(:,2);
zv=y(:,1).*z2./x23;

yiTail=0:y(end,2)/100:y(end,2);
plot3(0,0,0,'go');
hold on;
plot3(x2.*ones(1,size(yiTail,2)),yiTail,z2*ones(1,size(yiTail,2)),'r--');
hold on;
plot3(xv,yv,zv);
title('�ضԿյ������ͼ')
xlabel('x����(m)');
ylabel('y����(m)');
zlabel('����(m)');
legend('����λ��','�����켣','�ҷɻ��켣');
grid on
trail=[xv yv zv];
