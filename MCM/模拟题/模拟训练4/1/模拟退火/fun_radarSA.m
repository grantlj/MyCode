function recordProcess = fun_radarSA( data,a )
%��ע�������ֵ��

%���ڼ�¼����
recordProcess=[];
%���ò���
%a=0.97;
t0=500;
tf=5;
t=t0;
markovLength=100000;

%-----���ɳ�ʼ��
newPosi=creatInitPosi(data);
newE=fun_eFunction(newPosi,data);
currentPosi=newPosi;
currentE=newE;
bestPosi=newPosi;
bestE=newE;

while t>tf
    for r=1:markovLength
        
        dx=normrnd(0,10);
        dy=normrnd(0,10);
        dz=normrnd(0,10);
        
        newPosi=currentPosi+d;
        %����Ƿ����Լ��
        if fun_st(newPosi,data)==0
            continue;
        end
        newE=fun_eFunction(newPosi,data);        
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


function boolean=fun_st(posi,data)

eVec=((data(:,1)-posi(1)).^2+(data(:,2)-posi(2)).^2+posi(3).^2).^0.5-data(:,3);
if sum(abs(eVec)<=500)>0
    boolean=1;
else
    boolean=0;
end
end

function initPosi=creatInitPosi(data)
initPosi(1)=mean(data(:,1));
initPosi(2)=mean(data(:,2));
initPosi(3)=0;
while fun_st(initPosi,data)==0
    initPosi(3)=initPosi(3)+500;
end

end




