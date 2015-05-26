function recordProcess = fun_radarSA2secondStep( data,initPosition,isChange,a,st )
%请注意输入初值点

%用于记录过程
recordProcess=[];
%配置参数
%a=0.97;
t0=200;
tf=5;
t=t0;
markovLength=10000;

%-----生成初始解
newPosi=initPosition;

newE=fun_eFunction(newPosi,data);
currentPosi=newPosi;
currentE=newE;
bestPosi=newPosi;
bestE=newE;

while t>tf
    for r=1:markovLength
%产生扰动，三个-1~1的随机数

         dx=normrnd(0,4);
         dy=normrnd(0,4);
         dz=normrnd(0,4);
        
        
        newPosi=currentPosi+[dx dy dz].*isChange;
        newE=fun_eFunction(newPosi,data);
        %是否满足约束
        if fun_st(newPosi,data)==0&&st==1
            continue;
        end
        %检测是否被接受
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
    %记录过程
    recordProcess=[recordProcess;[t bestE bestPosi]];
end


end

%子函数，计算内能
function E = fun_eFunction( posi,data )
%计算内能的函数
eVec=((data(:,1)-posi(1)).^2+(data(:,2)-posi(2)).^2+posi(3).^2).^0.5-data(:,3);
E=sum(abs(eVec));
end

%约束函数
function boolean=fun_st(posi,data)

eVec=((data(:,1)-posi(1)).^2+(data(:,2)-posi(2)).^2+posi(3).^2).^0.5-data(:,3);
if sum(abs(eVec)<=70)>0
    boolean=1;
else
    boolean=0;
end
end
