clear
clc

%求解边缘线，并给出范围
%res矩阵 1~3行分别给椭圆、三角形和直线出最小值和最大值
res=zeros(3,2);
%由于考虑到的三种情况的桌边都是由椭圆构成，所以在设计边缘线过程总仅仅考虑椭圆情况


%给定一些参数

sitan= 75.3300*pi/180 ; %最外侧木条与地面的夹角
ironLoc= 4/8;%钢筋位置，表述为在最外木条上距最边的分位点
H=53  ;%桌子高度
b=2.5;  %木条宽度
thick=3;  %木板厚度
%椭圆参数
ovalA=25;
ovalB=30;
%开始投射，取视角角度为beta
beta=30*pi/180;

%出去板的厚度
H=H-thick;
%木条之间需要缝隙，所以就算整除也不行
n=2*ovalA/b; % n表示木条的数量
if ceil(n)==n
    %n是整数
    n=n-1;
else
    %n是非整数
    n=floor(n);
end
%缝隙长度gap计算
gap=(2*ovalA-n*b)/(n-1);

%求出每点的横坐标
for i=1:n
    x(i)=-2*ovalA/2+b/2+(i-1)*(gap+b);
end
%求出y的值
y=sqrt( ovalB^2.*( 1- (x./ovalA).^2 ) );

%根据sitan和yn的值，求解木板长度L
L=y(end)+H/sin(sitan);

%所有木条的长度
l=L-y;

%可以求出钢筋位置d
d=l(end)*ironLoc;
%计算开槽长度
slot=sqrt( ((l(end)-d)*cos(sitan)-(l(end)-l)).^2 +( (l(end)-d)*sin(sitan) )^2   )-(l-d);

%稳定状态下所有木条的与地面夹角sita
cb=sqrt(((l(end)-d)*cos(sitan)-( l(end)-l ) ).^2 + ( (l(end)-d)*sin(sitan) )^2);
cc=l(end)-l;
ca=l(end)-d;
sita= real(pi- acos( (cb.^2+cc.^2-ca.^2)./(2.*cb.*cc)));

%根据木条数是奇数还是偶数，计算相应的中间序列rm
if mod(n,2)==0
    rm=n/2;
else
    rm=(n+1)/2;
end


%假设进行补齐
p=d.*sin(sitan)./sin(pi-sita)-(l-cb);

%---------下面开始考虑投影平面------
%补齐后相对与最外投影位置差，作为投影面的y值，这里dia还是唯一对应他的x的值
dia=d.*sin(sita-sitan)./sin(pi-sita).*sin(beta);
dia([1,end])=0; %对其进行修正
slotDia=d*sin(sitan+beta);
%我们仅仅考虑从边上第二个点开始考虑形状
%对所有点进行调整，使得两侧第二个点位于X投影面X轴上
dia=dia-dia(end-1);
slotDia=slotDia-dia(end-1);

plot(x,dia,'*');
hold on 
plot(0,slotDia,'x');


res(:,2)=slotDia;
%首先求出椭圆的可以满足的最小值,使用离散求解的方式

for i=0:0.01:slotDia
    if sum(((x(3:n-2)./x(end-1)).^2+(dia(3:n-2)./i).^2)<=1)==size(x(3:n-2),2)
        %满足条件
        res(1,1)=i;
        break
    end
end

%其次求出三角形边缘线
for i=0:0.01:slotDia
    if sum( dia(3:rm)<=i.*( abs(x(2))-abs(x(3:rm)) )./abs(x(2)) )==size(x(3:rm),2)
        %满足条件
        res(2,1)=i;
        break
    end
end

%最后求出直线的范围
res(3,1)=max(dia);

disp(res);



