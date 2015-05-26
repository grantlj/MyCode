%分别代入甲乙丙的数据
firstData=[6650	3030	14177
7335	2230	13842
7335	3830	14176
8020	1430	13568
8020	4630	14215
8705	2230	13541
8705	3830	13860
10075	3030	13445];
secondData=[4650	2560	48469
5150	2985	47620
5150	2135	47538
5650	3410	46770
5650	1710	46605
6150	2135	45754
6150	2985	45837
6650	2560	44901];

thirdData=[7335	4570	104250
8705	4570	103240
7335	2170	106450
8705	2170	105440];

%三个的初值
firstInit=[mean(firstData(:,1)),mean(firstData(:,2)),10000];
secondInit=[mean(secondData(:,1)),mean(secondData(:,2)),10000];
thirdInit=[mean(thirdData(:,1)),mean(thirdData(:,2)),25000];

%计算和保存
firstProcess=fun_radarSA(firstData,firstInit,0.98);
save result1.mat;
secondProcess=fun_radarSA(secondData,secondInit,[1 1 1],0.98);
save result2.mat;
thirdProcess=fun_radarSA(thirdData,thirdInit,[1 1 1],0.99);
save result3.mat;

