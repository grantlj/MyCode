clear
clc

L=120; %ģ�峤��
W=50;    %ģ����
thick=3;  %ľ����
H=53;    %���Ӹ߶�

width=2.5; %ľ�����
H=H-thick;  %��ȥ��ȵĸ߶�

%ľ��֮����Ҫ��϶�����Ծ�������Ҳ����
n=W/width; % n��ʾľ��������

if ceil(n)==n
    %n������
    n=n-1;
else
    %n�Ƿ�����
    n=floor(n);
end

%��϶����gap����
gap=(W-n*width)/(n-1);


%Ϊ�˼򻯼���̶ȣ������Գ�����ϵ
%����ֻ������ά������xyz������0�ģ�������ȫ���Զѳɵõ�
%��ʱҪ����nΪ������ż�������
%m��ʾ�����ľ�����±�
if mod(n,2)==0
    %ż��
    m=n/2;
    for i=1:m
       x(i)=(gap+width)*(2*i-1)/2;
    end
else
    %����
    m=(n+1)/2;
    for i=1:m
        x(i)=(gap+width)*(i-1);
    end
end

%x��Ӧ��y����
y=((W/2)^2-x.^2).^0.5;
%ÿ��ľ���ĳ���
l=L/2-y;

%��������������н�
sita0=asin(H/l(end));

%����sita��
b=sqrt((l(end)/2*cos(sita0)-( l(end)-l ) ).^2 + ( l(end)/2*sin(sita0) )^2);
c=l(end)-l;
a=l(end)/2;
sita= pi- acos( (b.^2+c.^2-a.^2)./(2.*b.*c));


%������ľ�����������֪�������Լ�������Ǵ����ֵ����Ҫ����
xk=x;
yk=y+l.*cos(sita);
zk=l.*sin(sita);
yk(end)=y(end)+l(end)*cos(sita0);
zk(end)=l(end)*sin(sita0);

%��������

%debug
plot(yk,zk);


%�ɶԳ��Զ�ͼ���������
%���y�᾵��
xk=[xk -xk];x=[x -x];
yk=[yk yk];y=[y y];
zk=[zk zk];

%���x�᾵��
xk=[xk xk];x=[x x];
yk=[yk -yk];y=[y -y];
zk=[zk zk];

%����ÿ������
 for i=1:(size(x,2)) 
     plot3([x(i),xk(i)],[y(i),yk(i)],[0,-zk(i)],'linewidth',8,'color',[rand,rand,rand])    
     hold on
 end
 %��������
hold on
fun_drawCylinder(W/2,thick)


%���xyz����
xlabel('x');
ylabel('y');
zlabel('z');



