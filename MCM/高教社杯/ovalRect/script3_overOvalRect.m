clear
clc

%�˿�ȷ���иʽ1.��Բ  2.����   3.ֱ��
mode=2;
%�˿͸�������״����
height=20;



%����һЩ����,������script3_edge��һ��

sitan= 75.3300*pi/180 ; %�����ľ�������ļн�
ironLoc= 4/8;%�ֽ�λ�ã�����Ϊ������ľ���Ͼ���ߵķ�λ��
H=53  ;%���Ӹ߶�
b=2.5;  %ľ�����
thick=3;  %ľ����
%��Բ����
ovalA=25;
ovalB=30;
rectL=40;  %ֱ�߳���
%��ʼͶ��ʱ��ȡ�ӽǽǶ�Ϊbeta
beta=30*pi/180;

%��ȥ��ĺ��
H=H-thick;
%ľ��֮����Ҫ��϶�����Ծ�������Ҳ����
n=2*ovalA/b; % n��ʾľ��������
if ceil(n)==n
    %n������
    n=n-1;
else
    %n�Ƿ�����
    n=floor(n);
end
%��϶����gap����
gap=(2*ovalA-n*b)/(n-1);

%���ÿ��ĺ�����
for i=1:n
    x(i)=-2*ovalA/2+b/2+(i-1)*(gap+b);
end
%���y��ֵ
y=sqrt( ovalB^2.*( 1- (x./ovalA).^2 ) );

%����sitan��yn��ֵ�����ľ�峤��L
L=y(end)+H/sin(sitan);

%����ľ���ĳ���
l=L-y;

%��������ֽ�λ��d
d=l(end)*ironLoc;
%���㿪�۳���
slot=sqrt( ((l(end)-d)*cos(sitan)-(l(end)-l)).^2 +( (l(end)-d)*sin(sitan) )^2   )-(l-d);

%�ȶ�״̬������ľ���������н�sita
cb=sqrt(((l(end)-d)*cos(sitan)-( l(end)-l ) ).^2 + ( (l(end)-d)*sin(sitan) )^2);
cc=l(end)-l;
ca=l(end)-d;
sita= real(pi- acos( (cb.^2+cc.^2-ca.^2)./(2.*cb.*cc)));
sita([1,end])=sitan;

%����ľ��������������ż����������Ӧ���м�����rm
if mod(n,2)==0
    rm=n/2;
else
    rm=(n+1)/2;
end


%������в���
p=d.*sin(sitan)./sin(pi-sita)-(l-cb);
p([1,end])=0;

%---------���濪ʼ����ͶӰƽ��------
%��������������ͶӰλ�ò��ΪͶӰ���yֵ������dia����Ψһ��Ӧ����x��ֵ
dia=d.*sin(sita-sitan)./sin(pi-sita).*sin(beta);
dia([1,end])=0; %�����������
slotDia=d*sin(sitan+beta);
%���ǽ������Ǵӱ��ϵڶ����㿪ʼ������״
%�����е���е�����ʹ������ڶ�����λ��XͶӰ��X����
dia=dia-dia(end-1);
slotDia=slotDia-dia(end-1);


%��ʼ���ÿ��ľ����ӳ�����ϵ���ȥֵcut,ֻ��3~n-2�����е�
cut=zeros(size(dia));
switch mode
    case 1
        cut(3:(end-2))=sqrt( height^2*(1- ( x(3:(end-2))./x(end-1) ).^2 ) )-dia(3:(end-2));
    case 2
        cut(3:(end-2))=  height.*( abs(x(2))-abs(x(3:(end-2))) )./abs(x(2)) - dia(3:(end-2));
    case 3
        cut(3:(end-2))=height- dia(3:(end-2));
end

%-------���з�ӳ�䣬��ȡ����ҪԤ������״�������Ҫ���Ѿ��ӳ���ľ���Ͻ�����ȥ�ĳ���
cutReal=zeros(size(dia));
cutReal(3:(end-2))=cut(3:(end-2))./sin(pi-sita(3:(end-2))-beta);

%����p��catReal�����������ľ���ĸñ���
changeLen=p-cutReal;

%�������Ǹ�ľ��
Lmax=max(L+changeLen);
%���ÿ��ľ����ʵ�ʳ���
lReal=l+changeLen;
%ÿ��Ӧ����ĩβ�ص�����
cutTail=Lmax-(L+changeLen);


%-------��ʼ��̬ͼ--------
%��Ϊ��һ��ֱ�ߣ�������Ҫ��y��������
y=y+rectL/2;
%�ֳɶ��ٲ��� divide
divide=10;

%Ϊ�˻�����ͬ��ɫ�Ľţ��������ɫmap
colorMap=rand(size(x,2)*2,3);

for sitaNow=(sitan/divide):(sitan/divide):sitan    
    
    %��ǰsitaNow������ľ���������н�sita
    cb=sqrt(((l(end)-d)*cos(sitaNow)-( l(end)-l ) ).^2 + ( (l(end)-d)*sin(sitaNow) )^2);
    cc=l(end)-l;
    ca=l(end)-d;
    sita= real(pi- acos( (cb.^2+cc.^2-ca.^2)./(2.*cb.*cc)));
    sita([1,end])=sitaNow;
    
    xk=x;
    yk=y+lReal.*cos(sita);
    zk=lReal.*sin(sita);
    
    xk=[xk,xk]; x0=[x,x];
    yk=[yk,-yk]; y0=[y,-y];
    zk=[zk,zk];
    
    %�����������
    plot3( x,y,zeros(size(x)),'linewidth',8,'color','r');hold on
    plot3( x,-y,zeros(size(x)),'linewidth',8,'color','r');hold on
    plot3( [x(end),x(end)], [y(end),-y(end)],[0,0] ,'linewidth',8,'color','r');hold on
    plot3( [-x(end),-x(end)], [y(end),-y(end)],[0,0] ,'linewidth',8,'color','r');hold on
    
    for i=1:size(x0,2)
        plot3([x0(i),xk(i)],[y0(i),yk(i)],[0,-zk(i)],'linewidth',8,'color',colorMap(i,:));
        hold on;
    end
    
    
    %���xyz����
    xlabel('x');
    ylabel('y');
    zlabel('z');
    %�̶�������
    axis([-ovalA ovalA -Lmax Lmax -H thick+10]);
    %ȷ���ӽ�
    view(100,30);

    pause(0.5);
    hold off
end

disp(lReal);

