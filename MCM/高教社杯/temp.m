r0=2; %% radius
h0=4; %% height���ѵ����߶�
NN=20;
[X Y Z]=cylinder(r0,NN);
Z=h0*Z;
XX=X(2,: );
YY=Y(2,: );
Z1=Z(1,: );
Z2=Z(2,: );
%%% in this example I draw six cylinders
N=6;  %�Լ��޸���Ŀ
%  rotate this cylinders by Euler angles (th1,th2,th3) �Լ�����б��
TH1 = /180 *pi;
TH2 = /180 *pi;
TH3 = /180 *pi;
%%% centers of the cylinders�������޸�����������
x=;
y=;
z=;
for k=1:6
   th1=TH1(k);th2=TH2(k);th3=TH3(k); 
   R1=;
   R2=;
   R3=;
    A=R1*R2*R3;
    
    for i=1:NN+1
       r=';
       rT=A*r;
       XC(1,i)=rT(1);YC(1,i)=rT(2);ZC(1,i)=rT(3);
       r=';
       rT=A*r;
       XC(2,i)=rT(1);YC(2,i)=rT(2);ZC(2,i)=rT(3);
       
       r=';
       rT=A*r;
       XX1C(i)=rT(1);YY1C(i)=rT(2);Z1C(i)=rT(3);
       r=';
       rT=A*r;
       XX2C(i)=rT(1);YY2C(i)=rT(2);Z2C(i)=rT(3);
       
       
    end
    
    hold on;
fill3(XX1C+x(k),YY1C+y(k),Z1C+z(k),'green','EdgeColor','none');
hold on;
fill3(XX2C+x(k),YY2C+y(k),Z2C+z(k),'green','EdgeColor','none');
hold on;
XC=XC+x(k);YC=YC+y(k);ZC=ZC+z(k);
surf(XC,YC,ZC,'FaceColor','green','EdgeColor','none');
    
end
daspect()
view(3); axis tight
camlight 
lighting gouraud