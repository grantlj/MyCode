function [ H ] = fun_AOM( val3, bgval)
% ��xyz�����Ӧ��ֵ�ͱ���ֵ
%��AOM�����еĵ�����Ӧ��ֵ���һ���ͼ��
save=val3;
re=[];
%ѭ���������õ�Igeoֵ
for i=6:-0.05:0.05
    tempval= log( val3(:,3)./(bgval.*1.5)  )./log(2);
    is=(tempval>i);
    if 4<=sum(is)&&sum(is)<=6
        re=is;
        break;
    end
end
%��ֹ����û���ڹ涨����
if 4>sum(re)||sum(re)>6
    disp('error');
end
%����AOM
sumre=sum(re);
re=~re;
re=[re re re];
val3(re)=[];
val=reshape(val3,sumre,length(val3)./sumre);

%����AOM��Ҫ��ֵ
Igeo=log( val(:,3)./(bgval.*1.5)  )./log(2);
Igeo(Igeo<=0)=0;
Igeo=ceil(Igeo);
Igeo(Igeo>=6)=6;
val(:,4)=Igeo;

%��ÿ����İ뾶
for i=1:sumre
    val(i,5)=0;
    for j=1:sumre
        
        if j==i
            continue
        end
        val(i,5)=val(i,5)+val(j,4).*sqrt( (val(i,1)-val(j,1))^2 + (val(i,2)-val(j,2))^2 );
                
    end
end

 val(:,5)=val(:,5)./(sum(Igeo)-1);
%��ʼ��ͼ--
%���plot
plot(save(:,1),save(:,2),'go');
%��Բ
for i=1:sumre
    hold on
    fun_circle(val(i,1) , val(i,2) , val(i,5) );   
end
hold on
plot(val(:,1) , val(:,2),'r*');
axis([0 30000 0 20000])
%����ֵ
H=val;
end

function  fun_circle(x,y,R)
%��Բ
%���ڻ�Բ���Ӻ���
alpha=0:pi/50:2*pi;
X=x+R*cos(alpha); 
Y=y+R*sin(alpha); 
plot(X,Y,'b-') 

end



