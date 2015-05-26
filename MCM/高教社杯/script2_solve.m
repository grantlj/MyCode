clear

%����һ����λ�����������������Ľ������ָ�꣨�ȹ̣��ӹ������ϣ���һ�����м��������µı�ŷ�ʽ
%��֪������
H=70;
W=80;
b=2.5;  %ľ�����
thick=3;  %ľ����
%����
%ģ����ȷ����һЩ��
dn=8;

%��ȥ��ĺ��
H=H-thick;

%�����ڼ�¼���̵ľ���Ϊ
resultMat=[];

for j=1:(dn-1)
    %��Ե�j��λ��
    for sitan_range=1:0.01:90
        %ת��Ϊ����ֵ
        sitan=sitan_range*pi/180;
        %�����������£�����Ҫ�����ֵ
        
        
        
        %ľ��֮����Ҫ��϶�����Ծ�������Ҳ����
        n=W/b; % n��ʾľ��������

        if ceil(n)==n
            %n������
            n=n-1;
        else
            %n�Ƿ�����
            n=floor(n);
        end

        %��϶����gap����
        gap=(W-n*b)/(n-1);
        
        %���ÿ��ĺ�����
        for i=1:n
            x(i)=-W/2+b/2+(i-1)*(gap+b);
        end
        %y������0
        y=sqrt( (W/2)^2-x.^2 );
        
        %����sitan��yn��ֵ�����ľ�峤��L
        L=(y(end)+H/sin(sitan))*2;
        
        %����ľ���ĳ���
        l=L/2-y;
        
        %��������ֽ�λ��d
        d=l(end)*j/dn;
        
        %���㿪�۳���
        slot=sqrt( ((l(end)-d)*cos(sitan)-(l(end)-l)).^2 +( (l(end)-d)*sin(sitan) )^2   )-(l-d);
        
        %�ȶ�״̬������ľ���������н�sita
        cb=sqrt(((l(end)-d)*cos(sitan)-( l(end)-l ) ).^2 + ( (l(end)-d)*sin(sitan) )^2);
        cc=l(end)-l;
        ca=l(end)-d;
        sita= pi- acos( (cb.^2+cc.^2-ca.^2)./(2.*cb.*cc));
        
        %����ľ��������������ż����������Ӧ���м�����rm
        if mod(n,2)==0
            rm=n/2;
        else
            rm=(n+1)/2;
        end
        
        %�Ƿ������ĸ�Լ������
        %1.dֵС���м�ľ������   2.dֵ�����м�ղ۳���
        %��ȥ�����ľ�����ڿ�ס���1.sita(rm)>pi/2  2.sita(n-1)<pi/2
        %�ſ�֮��һ����ֻ���������ľ����Ӵ����棬���������z��ֵһ��Ҫ��� l(n)*sin(sita(n))>=max( l*sin(sita) )

        
        if d<l(rm)&&d>slot(rm)&&sita(rm)>pi/2&&sita(end-1)<pi/2&& l(end)*sin(sita(end))>=max( l.*sin(sita) )
            
            %�������ȹ���ָ��,����Ҫ�������
            SumTX=sum(-b.*y(2:(end-1)).*sin(sita(2:(end-1))).*cos(sita(2:(end-1))));
            
            %�����ӹ�����ָ�꣨���и�ȣ�
            man=sum( l(1:(end-1)) )+sum(slot)+W;
            
            %�ò�����
            material=L;
            
            resultMat=[resultMat;[ dn,j,sitan_range,abs(SumTX),man,material ]];            
        end    
    end        
end

disp(resultMat);

%debug  ����ͼ��
chooseJ=4;
data=resultMat(resultMat(:,2)==chooseJ,:);
data(:,4)=(max(data(:,4))-data(:,4))./(max(data(:,4))-min(data(:,4)));
data(:,5)=(max(data(:,5))-data(:,5))./(max(data(:,5))-min(data(:,5)));
data(:,6)=(max(data(:,6))-data(:,6))./(max(data(:,6))-min(data(:,6)));
plot( data(:,3),data(:,4),'*',data(:,3),data(:,5),'o',data(:,3),data(:,6),'x' );
legend('�����̶�','�ӹ����Ӷ�','���ϳ���')

%ȷ��������Ҫ�����Χ
scope=[0.02,0.1];

%�����¼����
optimal=[];

for i=(dn/2-1):(dn/2+1)
    data=resultMat(resultMat(:,2)==i,:);
    %���й�һ������ 
    data(:,4)=(data(:,4)-min(data(:,4)))./(max(data(:,4))-min(data(:,4)));
    data(:,5)=(data(:,5)-min(data(:,5)))./(max(data(:,5))-min(data(:,5)));
    data(:,6)=(data(:,6)-min(data(:,6)))./(max(data(:,6))-min(data(:,6)));
    
    retain=data( data(:,5)<scope(1) & data(:,6)<scope(2) ,:);
    %�����ȶ��Խ�������
    retain=sortrows(retain,4);
    %ȡ��õ��Ǹ��㣬�����м�¼
    if size(retain,1)>0
        optimal=[optimal;retain(1,:)];
    end
    
end
%��ӡ���Ž�
disp(optimal);





