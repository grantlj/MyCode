%ʹ��ģ���˻�����������
data=[7335,1370,107160;8705,1370,106150;7335,2170,106450;8705,2170,105440;7335,2970,105730;8705,2970,104720;7335,3770,105000;8705,3770,103990;7335,4570,104250;8705,4570,103240;7335,5370,103480;8705,5370,102480;];
recordProcess=[];
%���ò���
a=0.95;
t0=1000;
tf=5;
t=t0;
markovLength=100000;

%���ɳ�ʼ��
newPosi=[0 0 40000];
newE=fun_eFunction(newPosi,data(1:3,:));
currentPosi=newPosi;
currentE=newE;
bestPosi=newPosi;
bestE=newE;

while t>tf
    for r=1:markovLength
        %�����Ŷ�������-1~1�������
        dx=unifrnd(-2,2);
        dy=unifrnd(-2,2);
        dz=unifrnd(-2,2);
        newPosi=currentPosi+[dx dy dz];
        newE=fun_eFunction(newPosi,data(1:3,:));
        %����Ƿ񱻽���
        if newE<currentE
            currentE=newE;
            currentPosi=newPosi;
            if newE<bestE
                bestE=newE;
                bestPosi=newPosi;
                disp(bestE);
            end
        else
            if rand<exp(-(newE-currentE)./t)
                currentE=newE;
                currentPosi=newPosi;                
            end        
        end        
    end
    t=a*t;  
    %disp(t);
    recordProcess=[recordProcess;[t bestE bestPosi]];
    
end






