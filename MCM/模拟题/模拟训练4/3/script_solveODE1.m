clc
clear
x2=50366.7;
z2=13107.2;
t0=0;tf=50;
[t,y]=ode45('fun_eq',[t0,tf],[11283.5 348.8]);

while abs(y(end,1)-x2)>10
    tf=tf+1;
    [t,y]=ode45('fun_eq',[t0,tf],[11283.5 348.8]);
end

plot(11283.5,348.8,'o');
hold on;
plot(y(:,1),y(:,2),'r--');
hold on
yiTrail=0:y(end,2)/100:y(end,2);

plot(x2.*ones(1,size(yiTrail,2)),yiTrail,'b');
title('�նԿյ�����������и���ͼ')
xlabel('x����(m)');
ylabel('y����(m)');
legend('�׷ɻ�λ��','�����켣','�ҷɻ��켣');


