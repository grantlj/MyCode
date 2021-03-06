function [ Emin ,road1,road2,pro ] = fun_roadsSA( choose )
%FUN_ROADSSA 此处显示有关此函数的摘要
%   此处显示详细说明
%数据写入
%计算choose次的转运
%choose=2;
%每一个点的需求
demand=[-11,-4,-9;14,6,5;8,4,15;13,2,19;-13,-6,-13;-17,0,-1;0,9,-2;-6,-4,0;-8,-20,-10;26,27,9;17,20,7;6,18,18;-6,0,-11;0,-7,-18;-11,-17,0;-8,-22,-13;0,2,1;20,19,2;-13,-14,-4;-2,-18,-7;0,9,0;-6,0,0;0,0,-4;0,4,32;-8,0,0;-7,-6,-4;4,11,9;0,-8,-9;-1,-11,-12;9,6,0;];
demand=demand(:,choose);
n=size(demand,1);   
pro=[];%记录过程
%带停车场的距离矩阵
distanceMat=[0.000 	0.522 	1.065 	1.819 	1.137 	2.319 	2.937 	2.782 	3.860 	5.761 	1.612 	1.017 	0.560 	0.615 	0.199 	0.398 	1.211 	1.524 	0.985 	1.368 	1.794 	2.755 	2.772 	4.274 	3.397 	3.083 	2.857 	4.862 	0.633 	3.444 	2.571 
0.522 	0.000 	0.780 	1.534 	1.660 	2.033 	3.382 	2.804 	3.575 	5.476 	1.897 	1.302 	0.845 	0.900 	0.722 	0.921 	0.925 	2.047 	1.507 	1.890 	2.316 	2.470 	2.487 	3.989 	3.920 	3.605 	3.380 	4.577 	1.155 	3.454 	3.015 
1.065 	0.780 	0.000 	0.788 	1.866 	1.518 	3.588 	3.010 	3.223 	4.696 	2.677 	2.082 	1.626 	1.680 	1.177 	1.127 	0.175 	2.253 	1.713 	2.096 	2.522 	1.689 	1.963 	3.209 	4.126 	3.811 	3.586 	4.208 	1.361 	3.660 	3.221 
1.819 	1.534 	0.788 	0.000 	1.078 	0.730 	2.800 	2.222 	2.434 	3.943 	3.430 	2.835 	2.379 	2.433 	1.930 	1.800 	0.613 	1.543 	0.925 	1.308 	1.734 	0.936 	1.175 	2.455 	3.337 	3.023 	2.798 	3.420 	1.247 	2.872 	2.433 
1.137 	1.660 	1.866 	1.078 	0.000 	1.219 	1.838 	1.683 	2.761 	4.662 	2.711 	2.116 	1.660 	1.714 	1.211 	1.081 	1.691 	0.823 	0.204 	0.230 	0.657 	1.655 	1.673 	3.174 	2.260 	1.945 	1.720 	3.763 	0.528 	2.345 	1.471 
2.318 	2.033 	1.518 	0.730 	1.219 	0.000 	2.070 	1.492 	1.705 	3.443 	3.930 	3.335 	2.879 	2.933 	2.430 	2.300 	1.343 	2.043 	1.423 	1.146 	1.005 	0.436 	0.454 	1.955 	2.608 	2.293 	2.068 	2.690 	1.747 	2.143 	1.704 
2.937 	3.382 	3.588 	2.800 	1.838 	2.070 	0.000 	0.578 	0.923 	2.824 	4.549 	3.954 	3.498 	3.552 	3.048 	2.919 	3.413 	2.661 	2.042 	1.764 	1.368 	2.433 	1.625 	2.257 	1.274 	0.969 	0.671 	1.925 	2.365 	0.507 	0.367 
2.782 	2.804 	3.010 	2.222 	1.683 	1.492 	0.578 	0.000 	1.078 	2.979 	4.394 	3.798 	3.342 	3.397 	2.893 	2.764 	2.835 	2.506 	1.887 	1.609 	1.213 	1.855 	1.047 	1.679 	1.119 	0.814 	0.576 	2.080 	2.210 	0.662 	0.211 
3.860 	3.575 	3.222 	2.434 	2.761 	1.705 	0.923 	1.078 	0.000 	1.901 	5.471 	4.876 	4.420 	4.475 	3.971 	3.841 	3.048 	3.584 	2.964 	2.687 	2.291 	2.068 	1.260 	1.891 	2.197 	1.892 	1.594 	1.002 	3.288 	0.438 	1.289 
5.761 	5.476 	4.696 	3.942 	4.661 	3.442 	2.823 	2.979 	1.901 	0.000 	7.372 	6.777 	6.321 	6.375 	5.872 	5.742 	4.551 	5.485 	4.865 	4.588 	4.191 	3.006 	2.989 	2.055 	4.097 	3.793 	3.495 	0.899 	5.189 	2.317 	3.190 
1.612 	1.897 	2.677 	3.431 	2.711 	3.931 	4.549 	4.394 	5.472 	7.373 	0.000 	0.946 	1.296 	1.515 	1.501 	1.630 	2.822 	1.888 	2.507 	2.785 	3.181 	4.367 	4.384 	5.886 	3.275 	3.580 	3.878 	6.474 	2.184 	5.056 	4.183 
1.017 	1.302 	2.082 	2.835 	2.116 	3.335 	3.954 	3.799 	4.877 	6.778 	0.946 	0.000 	0.456 	0.569 	0.905 	1.035 	2.227 	1.518 	1.912 	2.189 	2.586 	3.771 	3.789 	5.291 	3.391 	3.077 	3.283 	5.878 	1.588 	4.460 	3.587 
0.560 	0.846 	1.626 	2.379 	1.660 	2.879 	3.498 	3.342 	4.421 	6.322 	1.296 	0.456 	0.000 	0.219 	0.543 	0.742 	1.771 	1.868 	1.456 	1.733 	2.138 	3.315 	3.333 	4.834 	3.741 	3.427 	3.201 	5.422 	1.132 	4.004 	3.131 
0.615 	0.900 	1.680 	2.434 	1.714 	2.933 	3.552 	3.397 	4.475 	6.376 	1.515 	0.569 	0.219 	0.000 	0.763 	0.962 	1.825 	2.088 	1.548 	1.931 	2.357 	3.370 	3.387 	4.889 	3.961 	3.646 	3.421 	5.477 	1.196 	4.059 	3.185 
0.199 	0.722 	1.177 	1.930 	1.211 	2.430 	3.049 	2.893 	3.971 	5.873 	1.501 	0.905 	0.543 	0.763 	0.000 	0.199 	1.322 	1.325 	1.007 	1.284 	1.681 	2.866 	2.884 	4.385 	3.198 	2.883 	2.658 	4.973 	0.683 	3.555 	2.682 
0.398 	0.921 	1.127 	1.800 	1.081 	2.300 	2.919 	2.764 	3.842 	5.743 	1.630 	1.035 	0.742 	0.962 	0.199 	0.000 	1.192 	1.126 	0.877 	1.154 	1.551 	2.736 	2.754 	4.256 	2.999 	2.684 	2.459 	4.844 	0.553 	3.426 	2.552 
1.210 	0.925 	0.175 	0.613 	1.691 	1.343 	3.413 	2.835 	3.048 	4.551 	2.822 	2.227 	1.771 	1.825 	1.322 	1.192 	0.000 	2.078 	1.538 	1.921 	2.347 	1.544 	1.788 	3.063 	3.951 	3.636 	3.411 	4.033 	1.186 	3.485 	3.047 
1.524 	2.047 	2.253 	1.543 	0.823 	2.043 	2.661 	2.506 	3.584 	5.485 	1.888 	1.518 	1.868 	2.088 	1.325 	1.126 	2.078 	0.000 	0.620 	0.897 	1.293 	2.479 	2.496 	3.998 	1.873 	1.692 	1.990 	4.586 	0.891 	3.168 	2.295 
0.985 	1.507 	1.713 	0.925 	0.204 	1.423 	2.042 	1.887 	2.965 	4.866 	2.507 	1.912 	1.456 	1.548 	1.007 	0.877 	1.538 	0.620 	0.000 	0.383 	0.809 	1.859 	1.877 	3.378 	2.413 	2.098 	1.873 	3.966 	0.352 	2.548 	1.675 
1.368 	1.890 	2.096 	1.308 	0.230 	1.146 	1.764 	1.609 	2.687 	4.588 	2.784 	2.189 	1.733 	1.931 	1.284 	1.154 	1.921 	0.897 	0.383 	0.000 	0.426 	1.582 	1.599 	3.101 	2.030 	1.715 	1.490 	3.689 	0.735 	2.271 	1.398 
1.794 	2.316 	2.522 	1.734 	0.657 	1.005 	1.368 	1.213 	2.291 	4.192 	3.181 	2.586 	2.138 	2.357 	1.681 	1.551 	2.347 	1.293 	0.809 	0.426 	0.000 	1.368 	1.203 	2.704 	1.603 	1.289 	1.063 	3.293 	1.161 	1.875 	1.001 
2.755 	2.469 	1.689 	0.936 	1.655 	0.436 	2.434 	1.856 	2.068 	3.007 	4.366 	3.771 	3.315 	3.369 	2.866 	2.736 	1.544 	2.479 	1.859 	1.582 	1.368 	0.000 	0.809 	1.519 	2.971 	2.656 	2.431 	3.053 	2.183 	2.506 	2.067 
2.772 	2.487 	1.963 	1.175 	1.673 	0.454 	1.625 	1.047 	1.260 	2.989 	4.384 	3.788 	3.332 	3.387 	2.883 	2.754 	1.788 	2.496 	1.877 	1.599 	1.203 	0.809 	0.000 	1.501 	2.162 	1.848 	1.623 	2.245 	2.200 	1.697 	1.258 
4.273 	3.988 	3.208 	2.455 	3.174 	1.955 	2.257 	1.679 	1.892 	2.056 	5.885 	5.290 	4.834 	4.888 	4.385 	4.255 	3.063 	3.997 	3.378 	3.101 	2.704 	1.519 	1.501 	0.000 	2.794 	2.480 	2.254 	2.877 	3.702 	2.329 	1.890 
3.397 	3.919 	4.125 	3.337 	2.260 	2.608 	1.274 	1.119 	2.197 	4.098 	3.275 	3.391 	3.741 	3.961 	3.198 	2.999 	3.950 	1.873 	2.412 	2.029 	1.603 	2.971 	2.162 	2.794 	0.000 	0.315 	0.603 	3.198 	2.764 	1.781 	0.907 
3.082 	3.605 	3.811 	3.023 	1.945 	2.293 	0.969 	0.814 	1.892 	3.793 	3.579 	3.077 	3.426 	3.646 	2.883 	2.684 	3.636 	1.692 	2.098 	1.715 	1.289 	2.656 	1.848 	2.480 	0.315 	0.000 	0.298 	2.894 	2.450 	1.476 	0.603 
2.857 	3.380 	3.585 	2.797 	1.720 	2.068 	0.671 	0.576 	1.594 	3.495 	3.878 	3.282 	3.201 	3.421 	2.658 	2.459 	3.411 	1.990 	1.873 	1.490 	1.063 	2.431 	1.622 	2.254 	0.603 	0.298 	0.000 	2.596 	2.224 	1.178 	0.364 
4.862 	4.577 	4.208 	3.420 	3.762 	2.690 	1.924 	2.080 	1.002 	0.899 	6.473 	5.878 	5.422 	5.476 	4.973 	4.843 	4.033 	4.586 	3.966 	3.689 	3.292 	3.053 	2.245 	2.877 	3.198 	2.894 	2.595 	0.000 	4.290 	1.418 	2.291 
0.633 	1.155 	1.361 	1.247 	0.528 	1.747 	2.365 	2.210 	3.288 	5.190 	2.184 	1.588 	1.132 	1.196 	0.683 	0.553 	1.186 	0.891 	0.352 	0.735 	1.161 	2.183 	2.200 	3.702 	2.764 	2.450 	2.224 	4.290 	0.000 	2.872 	1.999 
3.444 	3.454 	3.660 	2.872 	2.345 	2.143 	0.507 	0.662 	0.438 	2.317 	5.055 	4.460 	4.004 	4.059 	3.555 	3.425 	3.485 	3.168 	2.548 	2.271 	1.875 	2.506 	1.697 	2.329 	1.780 	1.476 	1.178 	1.418 	2.872 	0.000 	0.873 
2.571 	3.015 	3.221 	2.433 	1.471 	1.704 	0.367 	0.211 	1.289 	3.190 	4.182 	3.587 	3.131 	3.185 	2.682 	2.552 	3.046 	2.295 	1.675 	1.398 	1.001 	2.067 	1.258 	1.890 	0.907 	0.603 	0.364 	2.291 	1.999 	0.873 	0.000 ];

%时间=距离/速度*60分钟
timeMat=60.*distanceMat./30;
x1Mat=[];
x2Mat=[];
findNum=0;


%生成很多不同的路径，寻找n次
for i=1:200
    x1=1:15;x2=16:n;
    while fun_st(x1,x2 ,demand,50)==0
        
        %产生1~n-1的随机数(防止有一个路为0)
        num=0;
        while num<2||num>28
            num=round(normrnd(15,25));
        end                
        %分配n个点到两个路
        randroad=randperm(n);
        x1=randroad(1:num);
        x2=randroad((num+1):n);
    end
    %与前面的路是否相同
    flag=1;
    for j=1:findNum
        if findNum==0
            x1Mat=[x1Mat ; x1,zero(1,(n-size(x1,2)))];
            x2Mat=[x2Mat ; x2,zero(1,(n-size(x2,2)))];            
            findNum=findNum+1;
            break;
        end
        %首先取出第i个解到  xtemp与ytemp
        x1temp=x1Mat(j,:);
        x1temp(x1temp==0)=[];
        x2temp=x2Mat(j,:);
        x2temp(x2temp==0)=[];
        if fun_isRoadSim(x1temp,x2temp,x1,x2)==0
            %存在相同的
            flag=0;break;
        end            
    end
     %只有没出先相同的时候 flag才为1
     if flag==1         
         x1Mat=[x1Mat ; x1,zeros(1,(n-size(x1,2)))];
         x2Mat=[x2Mat ; x2,zeros(1,(n-size(x2,2)))];
         findNum=findNum+1;            
     end   
     disp('time   findNum');
     disp([ i ,findNum ]);
end













% 对所有找到的解进行模拟退火
%全局最优解
globalBestx1=[];
globalBestx2=[];
globalBest=20000;
for i=1:findNum
    
    %退火参数
    a=0.97;
	t0=500;
    tf=5;
    t=t0;
    markovLen=200000;
    
    %从求解矩阵中找出值
    sol_new1=x1Mat(i,:);
    sol_new1(sol_new1==0)=[];
    sol_new2=x2Mat(i,:);
    sol_new2(sol_new2==0)=[];
    E_new=fun_obj(sol_new1,sol_new2,demand,timeMat);
    sol_current1 = sol_new1;
    sol_current2 = sol_new2;
    E_current=E_new;
    sol_best1 = sol_new1;
    sol_best2 = sol_new2;
    E_best=E_new;
    %分割线
    pro=[pro ;[0 0]];
    pro=[pro ;[t,E_best]];

    
    %退火过程
    while t>=tf
        disp(t);
        for j=1:markovLen
           
            x1=sol_current1;
            x2=sol_current2;
            randnum=rand;
            %x1 x2 打乱顺序
            temp1=randperm(sum(x1>0));
            temp2=randperm(sum(x2>0));
            if randnum<0.166*1
                tmpnode=x1(temp1(1));
                x1(temp1(1))=x1(temp1(2));
                x1(temp1(2))=tmpnode;
            elseif randnum<0.166*2
                tmpnode=x1(temp1(1));
                x1(temp1(1))=0;
                x1=[x1(1:temp1(2)),tmpnode,x1((temp1(2)+1):end)];
                x1(x1==0)=[];
            elseif randnum<0.166*3
                tmpnode=x2(temp2(1));
                x2(temp2(1))=x2(temp2(2));
                x2(temp2(2))=tmpnode;
            elseif randnum<0.166*4   
                tmpnode=x2(temp2(1));
                x2(temp2(1))=0;
                x2=[x2(1:temp2(2)),tmpnode,x2((temp2(2)+1):end)];
                x2(x2==0)=[];
            elseif randnum<0.166*5  
                tmpnode=x1(temp1(1));
                x1(temp1(1))=x1(temp1(2));
                x1(temp1(2))=tmpnode;
                tmpnode=x2(temp2(1));
                x2(temp2(1))=x2(temp2(2));
                x2(temp2(2))=tmpnode;
            else
                tmpnode=x1(temp1(1));
                x1(temp1(1))=0;
                x1=[x1(1:temp1(2)),tmpnode,x1((temp1(2)+1):end)];
                x1(x1==0)=[];
                tmpnode=x2(temp2(1));
                x2(temp2(1))=0;
                x2=[x2(1:temp2(2)),tmpnode,x2((temp2(2)+1):end)];
                x2(x2==0)=[];
            end 
            sol_new1=x1;
            sol_new2=x2;
            E_new=fun_obj(sol_new1,sol_new2,demand,timeMat);
            %接受
            if E_new<E_current
                sol_current1=sol_new1;
                sol_current2=sol_new2;
                E_current=E_new;
                if E_current<E_best
                    sol_best1=sol_current1;
                    sol_best2=sol_current2;
                    E_best=E_current;
                    disp(E_best);
                    pro=[pro ;[t E_best]];
                end
            else
                if rand < exp(-(E_new-E_current)./t)
                    sol_current1=sol_new1;
                    sol_current2=sol_new2;
                    E_current=E_new;
                    if E_current<E_best
                        sol_best1=sol_current1;
                        sol_best2=sol_current2;
                        E_best=E_current; 
                        disp(E_best);
                        pro=[pro ;[t E_best]];
                    end
                end
            end
        end
        t=t*a;
    end
    if E_best<globalBest
        globalBest=E_best;
        globalBestx1=sol_best1;
        globalBestx2=sol_best2;
        disp('global best update');
    end
    
end

Emin= globalBest;
road1=sol_best1;
road2=sol_best2;

end

