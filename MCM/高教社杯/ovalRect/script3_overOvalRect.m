clear
clc

%顾客确定切割方式1.椭圆  2.三角   3.直线
mode=2;
%顾客给出的形状参数
height=20;



%给定一些参数,必须与script3_edge的一致

sitan= 75.3300*pi/180 ; %最外侧木条与地面的夹角
ironLoc= 4/8;%钢筋位置，表述为在最外木条上距最边的分位点
H=53  ;%桌子高度
b=2.5;  %木条宽度
thick=3;  %木板厚度
%椭圆参数
ovalA=25;
ovalB=30;
rectL=40;  %直边长度
%开始投射时，取视角角度为beta
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
sita([1,end])=sitan;

%根据木条数是奇数还是偶数，计算相应的中间序列rm
if mod(n,2)==0
    rm=n/2;
else
    rm=(n+1)/2;
end


%假设进行补齐
p=d.*sin(sitan)./sin(pi-sita)-(l-cb);
p([1,end])=0;

%---------下面开始考虑投影平面------
%补齐后相对与最外投影位置差，作为投影面的y值，这里dia还是唯一对应他的x的值
dia=d.*sin(sita-sitan)./sin(pi-sita).*sin(beta);
dia([1,end])=0; %对其进行修正
slotDia=d*sin(sitan+beta);
%我们仅仅考虑从边上第二个点开始考虑形状
%对所有点进行调整，使得两侧第二个点位于X投影面X轴上
dia=dia-dia(end-1);
slotDia=slotDia-dia(end-1);


%开始求解每个木条在映射面上的切去值cut,只在3~n-2上有切掉
cut=zeros(size(dia));
switch mode
    case 1
        cut(3:(end-2))=sqrt( height^2*(1- ( x(3:(end-2))./x(end-1) ).^2 ) )-dia(3:(end-2));
    case 2
        cut(3:(end-2))=  height.*( abs(x(2))-abs(x(3:(end-2))) )./abs(x(2)) - dia(3:(end-2));
    case 3
        cut(3:(end-2))=height- dia(3:(end-2));
end

%-------进行反映射，求取若需要预定的形状，求得需要在已经加长的木条上进行切去的长度
cutReal=zeros(size(dia));
cutReal(3:(end-2))=cut(3:(end-2))./sin(pi-sita(3:(end-2))-beta);

%根据p和catReal，可以求出个木条的该变量
changeLen=p-cutReal;

%求出最长的那个木条
Lmax=max(L+changeLen);
%求出每个木条的实际长度
lReal=l+changeLen;
%每条应该在末尾截掉多少
cutTail=Lmax-(L+changeLen);


%-------开始动态图--------
%因为有一个直边，所以需要对y进行修正
y=y+rectL/2;
%分成多少部分 divide
divide=10;

%为了画出不同颜色的脚，定义出颜色map
colorMap=rand(size(x,2)*2,3);

for sitaNow=(sitan/divide):(sitan/divide):sitan    
    
    %当前sitaNow下所有木条的与地面夹角sita
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
    
    %画出桌面边线
    plot3( x,y,zeros(size(x)),'linewidth',8,'color','r');hold on
    plot3( x,-y,zeros(size(x)),'linewidth',8,'color','r');hold on
    plot3( [x(end),x(end)], [y(end),-y(end)],[0,0] ,'linewidth',8,'color','r');hold on
    plot3( [-x(end),-x(end)], [y(end),-y(end)],[0,0] ,'linewidth',8,'color','r');hold on
    
    for i=1:size(x0,2)
        plot3([x0(i),xk(i)],[y0(i),yk(i)],[0,-zk(i)],'linewidth',8,'color',colorMap(i,:));
        hold on;
    end
    
    
    %标出xyz坐标
    xlabel('x');
    ylabel('y');
    zlabel('z');
    %固定坐标轴
    axis([-ovalA ovalA -Lmax Lmax -H thick+10]);
    %确定视角
    view(100,30);

    pause(0.5);
    hold off
end

disp(lReal);

