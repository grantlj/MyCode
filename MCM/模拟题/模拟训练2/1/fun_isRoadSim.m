function boolean = fun_isRoadSim( x1,x2,y1,y2 )
x1=round(x1);
x2=round(x2);
y1=round(y1);
y2=round(y2);
%检测两条路是否相等
boolean=0;
n=size(x1,2)+size(x2,2);

xm1=zeros(1,n);
xm1(x1)=1;
ym1=zeros(1,n);
ym1(y1)=1;
ym2=zeros(1,n);
ym2(y2)=1;

if sum(xm1==ym1)==n || sum(xm1==ym2)==n
    boolean=1;
end


end

