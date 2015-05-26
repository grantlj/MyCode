clear
clc

%����Ե�ߣ���������Χ
%res���� 1~3�зֱ����Բ�������κ�ֱ�߳���Сֵ�����ֵ
res=zeros(3,2);
%���ڿ��ǵ���������������߶�������Բ���ɣ���������Ʊ�Ե�߹����ܽ���������Բ���


%����һЩ����

sitan= 75.3300*pi/180 ; %�����ľ�������ļн�
ironLoc= 4/8;%�ֽ�λ�ã�����Ϊ������ľ���Ͼ���ߵķ�λ��
H=53  ;%���Ӹ߶�
b=2.5;  %ľ�����
thick=3;  %ľ����
%��Բ����
ovalA=25;
ovalB=30;
%��ʼͶ�䣬ȡ�ӽǽǶ�Ϊbeta
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

%����ľ��������������ż����������Ӧ���м�����rm
if mod(n,2)==0
    rm=n/2;
else
    rm=(n+1)/2;
end


%������в���
p=d.*sin(sitan)./sin(pi-sita)-(l-cb);

%---------���濪ʼ����ͶӰƽ��------
%��������������ͶӰλ�ò��ΪͶӰ���yֵ������dia����Ψһ��Ӧ����x��ֵ
dia=d.*sin(sita-sitan)./sin(pi-sita).*sin(beta);
dia([1,end])=0; %�����������
slotDia=d*sin(sitan+beta);
%���ǽ������Ǵӱ��ϵڶ����㿪ʼ������״
%�����е���е�����ʹ������ڶ�����λ��XͶӰ��X����
dia=dia-dia(end-1);
slotDia=slotDia-dia(end-1);

plot(x,dia,'*');
hold on 
plot(0,slotDia,'x');


res(:,2)=slotDia;
%���������Բ�Ŀ����������Сֵ,ʹ����ɢ���ķ�ʽ

for i=0:0.01:slotDia
    if sum(((x(3:n-2)./x(end-1)).^2+(dia(3:n-2)./i).^2)<=1)==size(x(3:n-2),2)
        %��������
        res(1,1)=i;
        break
    end
end

%�����������α�Ե��
for i=0:0.01:slotDia
    if sum( dia(3:rm)<=i.*( abs(x(2))-abs(x(3:rm)) )./abs(x(2)) )==size(x(3:rm),2)
        %��������
        res(2,1)=i;
        break
    end
end

%������ֱ�ߵķ�Χ
res(3,1)=max(dia);

disp(res);



