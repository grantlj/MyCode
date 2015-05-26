%-------------��������
data=[4650	2560	48469
5150	2985	47620
5150	2135	47538
5650	3410	46770
5650	1710	46605
6150	2135	45754
6150	2985	45837
6650	2560	44901];
%��data��Ϊ����
data=data./1000;

height=1.3;
dHeight=0.3;

%--------------���ò���
tolerance=0.01;                        %�������
maxNum=10000000;                    %��������������
nVars=3;                         %Ŀ�꺯�����Ա�������
particleScale=100;                %����Ⱥ��ģ
c1=2;                            %ÿ�����ӵĸ���ѧϰ���ӣ�Ҳ��Ϊ���ٳ���
c2=2;                            %ÿ�����ӵ����ѧϰ���ӣ�Ҳ��Ϊ���ٳ���
w=0.6;                           %��������
maxSpeed=0.1;                        %���ӵ��������ٶ�
a=1;                           %Լ������

%-----------��ʼ��
%�������ڵ�λ�����ӵķ����ٶ�
[posi,speed]=fun_init(particleScale,maxSpeed,height,dHeight,data);

%���ÿ�������Ӧ���
for i=1:particleScale
    f(i)=fun_obj(posi(i,:),data);
end
%��ʼ��ȫ�����ź;ֲ�����
personalBestPosi=posi;
personalBestFaval=f;

[globalbestFaval,i]=min(personalBestFaval);
globalbestPosi=personalBestPosi(i,:);
%��ʼ����
k=1;
while k<maxNum
    if mod(k,10000)==0
        disp(globalbestFaval);
    end
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
    %����ÿ������ٶ�
    for i=1:particleScale 
        speed(i,:)=w*speed(i,:)+c1*rand*(personalBestPosi(i,:)-posi(i,:))+c2*rand*(globalbestPosi-posi(i,:));    
    end
    speed(speed>maxSpeed)=maxSpeed;
    speed(speed<-maxSpeed)=-maxSpeed;
    %����λ��
    posi=posi+speed;
    if abs(globalbestFaval)<tolerance
        break
    end
    k=k+1;

    

end


















