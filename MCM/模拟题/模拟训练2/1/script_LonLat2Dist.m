clear
clc
plot=[108.952532  34.347572];
%1~30的经纬度矩阵
LonLat=[108.952954	34.324828
108.948562	34.323762
108.943199	34.326341
108.943387	34.333265
108.953161	34.334874
108.944636	34.338787
108.952532	34.350865
108.950232	34.347572
108.945525	34.353369
108.936075	34.362644
108.966896	34.321862
108.958515	34.320289
108.954131	34.320766
108.953233	34.319536
108.954643	34.325223
108.95502	34.326699
108.94336	34.327779
108.959745	34.332914
108.953439	34.333272
108.954014	34.336238
108.954176	34.339934
108.940288	34.339114
108.944591	34.342825
108.932985	34.34673
108.962386	34.347557
108.959018	34.347512
108.95617	34.34784
108.945435	34.362294
108.953287	34.330239
108.95017	34.353466
];

%三次的需求
demand=[15	22	30
23	24	35
38	28	31
38	32	22
17	23	28
32	12	10
13	35	34
40	22	16
26	19	19
18	31	37
18	24	27
35	20	33
7	27	28
12	19	13
38	16	12
17	22	6
21	39	23
23	38	32
28	20	20
23	21	20
15	33	34
35	7	6
15	20	38
34	9	10
21	9	13
23	21	20
35	30	35
18	21	20
13	22	17
18	30	38 ];

n=size(LonLat,1);

%求出任意两点的距离
for i=1:n
    for j=1:n
        distMat(i,j)=distance(LonLat(i,2),LonLat(i,1),LonLat(i,2),LonLat(j,1),6378.1)+distance(LonLat(i,2),LonLat(j,1),LonLat(j,2),LonLat(j,1),6378.1);
    end
end

    

%对distanceMatrix取倒数,并使小于1/2的为0，最后归一化，
%得到i到j点的概率
distMatDown=1./distMat;
distMatDown(distMatDown<0.5)=0;
distMatDown(distMatDown==inf)=0;
sumRows=sum(distMatDown,2);
for i=1:n
    probabMat(i,:)=distMatDown(i,:)./sumRows(i,1);
end

%用probabMat与demand矩阵，求每个次点的是多了还是少了（少了为负，多了为正），储存在changeMat。（30*3）;
for i=1:3
    for j=1:n
        
        for k=1:n
            tempMat(k,:)=probabMat(k,:).*demand(k,i);
        end
        changeMat(j,i)=sum(tempMat(:,j))-sum(tempMat(j,:));
            
    end
end

changeMat=round(changeMat);

%修正可能出现的出于入不平衡
banlance=sum(changeMat);
for i=1:3
    for j=1:abs(banlance(i))
        if banlance(i)==0
            continue;
        elseif banlance(i)>0
            changeMat(j,i)=changeMat(j,i)-1;
        else
            changeMat(j,i)=changeMat(j,i)+1;
        end
    end
end

realDemand=ceil(demand.*1.1);
realDemand(realDemand>40)=40;

%求出realDemand与changeMat之后放入LinGO求解，得到initVal
initVal=[22;27;33;27;37;39;40;32;35;40;36;25;22;26;31;36;18;26;28;40;38;40;25;26;30;26;21;20;36;40;20;27;31;39;22;37;19;32;31;14;22;19;40;18;19;21;25;10;30;40;27;26;40;38;31;22;22;26;30;22;28;39;38;39;22;30;19;38;40;38;12;11;24;11;19;26;24;22;39;33;39;25;24;22;15;26;19;26;40;40;];
initVal=reshape(initVal,3,n)';

transportMat(:,1)=initVal(:,2)-(initVal(:,1)+changeMat(:,1));
transportMat(:,2)=initVal(:,3)-(initVal(:,2)+changeMat(:,2));
transportMat(:,3)=initVal(:,1)-(initVal(:,3)+changeMat(:,3));

%求出带停车场的
plot=[108.952532  34.347572];
plotLonLat=[LonLat;plot];
for i=1:(n+1)
    for j=1:(n+1)
        plotDistMat(i,j)=distance(plotLonLat(i,2),plotLonLat(i,1),plotLonLat(i,2),plotLonLat(j,1),6378.1)+distance(plotLonLat(i,2),plotLonLat(j,1),plotLonLat(j,2),plotLonLat(j,1),6378.1);
    end
end

timeMat=60*plotDistMat./30;
