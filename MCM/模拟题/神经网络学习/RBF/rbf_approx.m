clc;
clear;
close all;

%???????, generate the learing data
ld=200; %???????
x=rand(2,ld); %0-1
x=(x-0.5)*1.5*2; %-1.5, 1.5
x1=x(1,:);
x2=x(2,:);
F=20+x1.^2-10*cos(2*pi*x1)+x2.^2-10*cos(2*pi*x2);


%???????
net=newrb(x,F);

%generate the testing data
interval=0.01;
[i, j]=meshgrid(-1.5:interval:1.5);
row=size(i);
tx1=i(:);
tx1=tx1';
tx2=j(:);
tx2=tx2';
tx=[tx1;tx2];

%testing
ty=sim(net,tx);

v=reshape(ty,row);
figure
subplot(1,3,2)
mesh(i,j,v);
zlim([0,60])

%plot the original function
interval=0.01;
[x1, x2]=meshgrid(-1.5:interval:1.5);
F = 20+x1.^2-10*cos(2*pi*x1)+x2.^2-10*cos(2*pi*x2);
subplot(1,3,1)
mesh(x1,x2,F);
zlim([0,60])

%plot the error
subplot(1,3,3)
mesh(x1,x2,F-v);
zlim([0,60])

