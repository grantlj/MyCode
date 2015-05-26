function [process,posi] = fun_radarPSO( data )
%FUN_RADARPSO Summary of this function goes here
%��¼����
process=[];
%--------------���ò���
tolerance=200;           %�������
maxNum=10000;                    %��������������
%nVars=3;                         %Ŀ�꺯�����Ա�������
particleScale=200;                %����Ⱥ��ģ
c1=2;                            %ÿ�����ӵĸ���ѧϰ���ӣ�Ҳ��Ϊ���ٳ���
c2=2;                            %ÿ�����ӵ����ѧϰ���ӣ�Ҳ��Ϊ���ٳ���
w=0.8;                           %��������
maxSpeed=2000;                        %����������ά���ϵ��������ٶ�
a=1;                           %Լ������

%-----------��ʼ��
%�������ڵ�λ�����ӵķ����ٶ�
[posi,speed]=fun_init(particleScale,maxSpeed,data);

%���ÿ�������Ӧ���
for i=1:particleScale
    f(i)=fun_obj(posi(i,:),data);
end
%��ʼ��ȫ�����ź;ֲ�����
personalBestPosi=posi;
personalBestFaval=f;

[globalbestFaval,i]=min(personalBestFaval);
globalbestPosi=personalBestPosi(i,:);
process=[process;[globalbestFaval,globalbestPosi]];
%��ʼ����
k=1;
while k<maxNum
    
    
    %���ÿ�����ӵ�����
    for i=1:particleScale
        f(i)=fun_obj(posi(i,:),data);
        %�жϵ�ǰλ���Ƿ�����ʷ�����λ��
        if f(i)<personalBestFaval(i) 
            personalBestFaval(i)=f(i);
            personalBestPosi(i,:)=posi(i,:);
            
        end        
    end
    %���ȫ������
    [globalbestFaval,i]=min(personalBestFaval);
    globalbestPosi=personalBestPosi(i,:);
    if mod(k,100)==0
        %process=[process;[globalbestFaval,globalbestPosi]];
        disp(k);
        disp(globalbestFaval);
        disp(globalbestPosi);
    end
    process=[process;[globalbestFaval,globalbestPosi]];
    
    %����ÿ������ٶ�
    for i=1:particleScale 
        speed(i,:)=w*speed(i,:)+c1*rand*(personalBestPosi(i,:)-posi(i,:))+c2*rand*(globalbestPosi-posi(i,:));    
    end
    speed(speed>maxSpeed)=maxSpeed;
    speed(speed<-maxSpeed)=-maxSpeed;
    %����λ��
    posi=posi+speed;
    if globalbestFaval<tolerance
        break
    end
    k=k+1; 
%     %��ͼ
%     if k==2
%         plot3(posi(:,1),posi(:,2),posi(:,3),'y*');
%         hold on
%         pause(1);
%     elseif k==300
%         plot3(posi(:,1),posi(:,2),posi(:,3),'g*');
%         hold on
%         pause(1);
%     elseif k==600
%         plot3(posi(:,1),posi(:,2),posi(:,3),'b*');
%         hold on
%         pause(1);
%     elseif k==1000
%         plot3(posi(:,1),posi(:,2),posi(:,3),'r*');
%         hold on
%         pause(1);
%     end
end

end

function boolean=fun_st(posi,data)

eVec=((data(:,1)-posi(1)).^2+(data(:,2)-posi(2)).^2+posi(3).^2).^0.5-data(:,3);
if sum(abs(eVec)<=50)>0
    boolean=1;
else
    boolean=0;
end
end

function [ posi,speed ] = fun_init( particleScale,maxSpeed,data )
%��ʼ������Ⱥ��λ�ú��ٶ�
posi=[];
speed=[];
%-------��ʼ��λ��

for i=1: particleScale
    newPosi=[mean(data(:,1)) mean(data(:,2)) 0];
    fayi=pi*unifrnd(0.01,0.5);
    sita=pi*unifrnd(-1,1);
    dz=100*sin(fayi);
    dx=100*cos(fayi)*cos(sita);
    dy=100*cos(fayi)*sin(sita);
    d=[dx dy dz];
    
    while fun_st(newPosi,data)==0
        newPosi=newPosi+d;
    end
    posi=[posi;newPosi];
end


%-------��ʼ���ٶ�
speed=unifrnd(-1,1,[particleScale,3]).*maxSpeed;

end

function obj = fun_obj( posi,data )
%�������ܵĺ���
eVec=((data(:,1)-posi(1)).^2+(data(:,2)-posi(2)).^2+posi(3).^2).^0.5-data(:,3);
obj=sum(abs(eVec));
end
