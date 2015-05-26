%使用模拟退火解决误差的问题
data=[7335,1370,107160;8705,1370,106150;7335,2170,106450;8705,2170,105440;7335,2970,105730;8705,2970,104720;7335,3770,105000;8705,3770,103990;7335,4570,104250;8705,4570,103240;7335,5370,103480;8705,5370,102480;];
recordProcess=[];
%配置参数
a=0.95;
t0=1000;
tf=5;
t=t0;
markovLength=100000;

%生成初始解
newPosi=[0 0 40000];
newE=fun_eFunction(newPosi,data(1:3,:));
currentPosi=newPosi;
currentE=newE;
bestPosi=newPosi;
bestE=newE;

while t>tf
    for r=1:markovLength
        %产生扰动，三个-1~1的随机数
        dx=unifrnd(-2,2);
        dy=unifrnd(-2,2);
        dz=unifrnd(-2,2);
        newPosi=currentPosi+[dx dy dz];
        newE=fun_eFunction(newPosi,data(1:3,:));
        %检测是否被接受
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






