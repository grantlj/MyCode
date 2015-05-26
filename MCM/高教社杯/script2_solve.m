clear

%求在一定分位点下所有满足条件的解的三项指标（稳固，加工，用料），一下所有计算就针对新的标号方式
%已知常量：
H=70;
W=80;
b=2.5;  %木条宽度
thick=3;  %木板厚度
%根据
%模型中确定的一些量
dn=8;

%出去板的厚度
H=H-thick;

%设用于记录过程的矩阵为
resultMat=[];

for j=1:(dn-1)
    %针对地j分位点
    for sitan_range=1:0.01:90
        %转换为弧度值
        sitan=sitan_range*pi/180;
        %针对这个条件下，我需要求各种值
        
        
        
        %木条之间需要缝隙，所以就算整除也不行
        n=W/b; % n表示木条的数量

        if ceil(n)==n
            %n是整数
            n=n-1;
        else
            %n是非整数
            n=floor(n);
        end

        %缝隙长度gap计算
        gap=(W-n*b)/(n-1);
        
        %求出每点的横坐标
        for i=1:n
            x(i)=-W/2+b/2+(i-1)*(gap+b);
        end
        %y轴恒大于0
        y=sqrt( (W/2)^2-x.^2 );
        
        %根据sitan和yn的值，求解木板长度L
        L=(y(end)+H/sin(sitan))*2;
        
        %所有木条的长度
        l=L/2-y;
        
        %可以求出钢筋位置d
        d=l(end)*j/dn;
        
        %计算开槽长度
        slot=sqrt( ((l(end)-d)*cos(sitan)-(l(end)-l)).^2 +( (l(end)-d)*sin(sitan) )^2   )-(l-d);
        
        %稳定状态下所有木条的与地面夹角sita
        cb=sqrt(((l(end)-d)*cos(sitan)-( l(end)-l ) ).^2 + ( (l(end)-d)*sin(sitan) )^2);
        cc=l(end)-l;
        ca=l(end)-d;
        sita= pi- acos( (cb.^2+cc.^2-ca.^2)./(2.*cb.*cc));
        
        %根据木条数是奇数还是偶数，计算相应的中间序列rm
        if mod(n,2)==0
            rm=n/2;
        else
            rm=(n+1)/2;
        end
        
        %是否满足四个约束条件
        %1.d值小于中间木条长度   2.d值大于中间空槽长度
        %除去最外侧木条用于卡住轴的1.sita(rm)>pi/2  2.sita(n-1)<pi/2
        %张开之后一定是只有最外面的木条会接触地面，所以最外侧z轴值一定要最大 l(n)*sin(sita(n))>=max( l*sin(sita) )

        
        if d<l(rm)&&d>slot(rm)&&sita(rm)>pi/2&&sita(end-1)<pi/2&& l(end)*sin(sita(end))>=max( l.*sin(sita) )
            
            %首先求稳固性指标,不需要求两侧的
            SumTX=sum(-b.*y(2:(end-1)).*sin(sita(2:(end-1))).*cos(sita(2:(end-1))));
            
            %其次求加工方便指标（总切割长度）
            man=sum( l(1:(end-1)) )+sum(slot)+W;
            
            %用材最少
            material=L;
            
            resultMat=[resultMat;[ dn,j,sitan_range,abs(SumTX),man,material ]];            
        end    
    end        
end

disp(resultMat);

%debug  画出图像
chooseJ=4;
data=resultMat(resultMat(:,2)==chooseJ,:);
data(:,4)=(max(data(:,4))-data(:,4))./(max(data(:,4))-min(data(:,4)));
data(:,5)=(max(data(:,5))-data(:,5))./(max(data(:,5))-min(data(:,5)));
data(:,6)=(max(data(:,6))-data(:,6))./(max(data(:,6))-min(data(:,6)));
plot( data(:,3),data(:,4),'*',data(:,3),data(:,5),'o',data(:,3),data(:,6),'x' );
legend('受力程度','加工复杂度','用料长度')

%确定两个需要的最大范围
scope=[0.02,0.1];

%结果记录矩阵
optimal=[];

for i=(dn/2-1):(dn/2+1)
    data=resultMat(resultMat(:,2)==i,:);
    %进行归一化操作 
    data(:,4)=(data(:,4)-min(data(:,4)))./(max(data(:,4))-min(data(:,4)));
    data(:,5)=(data(:,5)-min(data(:,5)))./(max(data(:,5))-min(data(:,5)));
    data(:,6)=(data(:,6)-min(data(:,6)))./(max(data(:,6))-min(data(:,6)));
    
    retain=data( data(:,5)<scope(1) & data(:,6)<scope(2) ,:);
    %按照稳定性进行排序
    retain=sortrows(retain,4);
    %取最好的那个点，并进行记录
    if size(retain,1)>0
        optimal=[optimal;retain(1,:)];
    end
    
end
%打印最优解
disp(optimal);





