function recordProcess = fun_radarSA2secondStep( data,initPosition,isChange,a,st )
%��ע�������ֵ��

%���ڼ�¼����
recordProcess=[];
%���ò���
%a=0.97;
t0=200;
tf=5;
t=t0;
markovLength=10000;

%-----���ɳ�ʼ��
newPosi=initPosition;

newE=fun_eFunction(newPosi,data);
currentPosi=newPosi;
currentE=newE;
bestPosi=newPosi;
bestE=newE;

while t>tf
    for r=1:markovLength
%�����Ŷ�������-1~1�������

         dx=normrnd(0,4);
         dy=normrnd(0,4);
         dz=normrnd(0,4);
        
        
        newPosi=currentPosi+[dx dy dz].*isChange;
        newE=fun_eFunction(newPosi,data);
        %�Ƿ�����Լ��
        if fun_st(newPosi,data)==0&&st==1
            continue;
        end
        %����Ƿ񱻽���
        if newE<currentE
            currentE=newE;
            currentPosi=newPosi;
            if newE<bestE
                bestE=newE;
                bestPosi=newPosi;
                disp(bestE);
                disp(bestPosi);
            end
        else
            if rand<exp(-(newE-currentE)./t)
                currentE=newE;
                currentPosi=newPosi;                
            end        
        end        
    end
    t=a*t;  
    %��¼����
    recordProcess=[recordProcess;[t bestE bestPosi]];
end


end

%�Ӻ�������������
function E = fun_eFunction( posi,data )
%�������ܵĺ���
eVec=((data(:,1)-posi(1)).^2+(data(:,2)-posi(2)).^2+posi(3).^2).^0.5-data(:,3);
E=sum(abs(eVec));
end

%Լ������
function boolean=fun_st(posi,data)

eVec=((data(:,1)-posi(1)).^2+(data(:,2)-posi(2)).^2+posi(3).^2).^0.5-data(:,3);
if sum(abs(eVec)<=70)>0
    boolean=1;
else
    boolean=0;
end
end
