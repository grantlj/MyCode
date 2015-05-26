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

%�����������������н�
sita0=asin(H/l(end));

%Ϊ�˻�����ͬ��ɫ�Ľţ��������ɫmap
colorMap=rand(size(x,2)*4,3);

%���һ�����󣬼�¼���а�����ƶ��Ĺ���
recordProcess=[];

%�ֳɶ��ٲ��� divide
divide=10;
for sitaNow=(sita0/divide):(sita0/divide):sita0
    hold off;
    %����sita��
    b=sqrt((l(end)/2*cos(sitaNow)-( l(end)-l ) ).^2 + ( l(end)/2*sin(sitaNow) )^2);
    c=l(end)-l;
    a=l(end)/2;
    sita= pi- acos( (b.^2+c.^2-a.^2)./(2.*b.*c));


    %������ľ�����������֪�������Լ�������Ǵ����ֵ����Ҫ����
    xk=x;
    yk=y+l.*cos(sita);
    zk=l.*sin(sita);
    yk(end)=y(end)+l(end)*cos(sitaNow);
    zk(end)=l(end)*sin(sitaNow);

    %�ɶԳ��Զ�ͼ���������
    xk=[xk -xk];
    x0=[x -x];
    yk=[yk yk];
    y0=[y y];
    zk=[zk zk];
    recordProcess=cat(3, recordProcess, [ xk; yk; zk ] );
    xk=[xk xk];
    x0=[x0 x0];
    yk=[yk -yk];
    y0=[y0 -y0];
    zk=[zk zk];

    %����ÿ������
     for i=1:(size(x0,2)) 
         plot3([x0(i),xk(i)],[y0(i),yk(i)],[0,-zk(i)],'linewidth',8,'color',colorMap(i,:))    
         hold on
     end
     
    %��������
    fun_drawCylinder(W/2,thick)
    %���xyz����
    xlabel('x');
    ylabel('y');
    zlabel('z');
    %�̶�������
    axis([-W/2 W/2 -L/2 L/2 -H thick+10]); 
    %ȷ���ӽ�
    view(100,30);
    %��ͣʱ����л�ͼ
    pause(5);   
end


%�����켣��
for i=1:size(recordProcess,2)
    hold on
    plot3( reshape(recordProcess(1,i,:), 1,size(recordProcess,3) ),reshape(recordProcess(2,i,:), 1,size(recordProcess,3) ),-reshape(recordProcess(3,i,:), 1,size(recordProcess,3) ) );
end
