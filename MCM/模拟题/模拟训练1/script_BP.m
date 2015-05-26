clear
clc
%国外的数据
data=[73.8	73.9	74.7	74.5	75.6	76.8	74	    74.1	75.4	75.6	72.1	75	77.2	76	    74.1	74.9	76.1	75.2	81.5	75.2	81.6	75.4	74.9	67.1;
     15	    14.9	16  	16.4	17.6	11.7	11.3	14.4	13.6	15.5	15.6	17	17.4	12.6	12.3	11.7	12.3	17  	17  	18.1	18.1	12.4	15.6	14.6;
  10.465	10.365	9.84	9.985	9.005	8.84	9.525	9.245	9.615	10.84	6.64	8.87	10.28	11.245	12.43	9.065	9.86	10.165	10.165	8.285	8.285	6.945	9.905	9.955;
67	65	60	65	65	67	66	65	65	67	65	65	65	65	65	65	65	65	62	65	60	61	65	62 ];
%中国的数据
china=[70.61 	70.93 	71.25 	71.58 	71.89 	72.19 	72.51 	72.83 	73.15 	73.47 	73.79 	74.10 	74.42 	74.74 	75.06 	75.38 	75.70 	76.01 	76.33 	76.65 	76.96 	77.28 	77.59 	77.90 	78.22 	78.53 	78.85 	79.17 	79.48 	79.80 	80.12 	80.44 	80.75 	81.07 ;
6.55 	6.70 	6.83 	6.99 	7.23 	7.27 	7.36 	7.57 	7.82 	7.96 	7.99 	8.16 	8.42 	8.67 	8.92 	9.42 	9.72 	10.00 	10.31 	10.63 	10.97 	11.29 	11.59 	11.89 	12.21 	12.53 	12.84 	13.15 	13.47 	13.78 	14.10 	14.41 	14.72 	15.04 ;
5.93 	6.04 	6.15 	6.26 	6.38 	6.50 	6.61 	6.72 	6.83 	6.94 	7.05 	7.16 	7.28 	7.39 	7.50 	7.61 	7.72 	7.83 	7.95 	8.06 	8.17 	8.28 	8.40 	8.51 	8.62 	8.73 	8.84 	8.96 	9.07 	9.18 	9.29 	9.40 	9.52 	9.63 ];
%输入矩阵
D=data(1:3,:);
%输出归一化
age=data(4,:);
age=(age-60)./10;
%创建网络
net_1=newff(minmax(D),[15,10,1],{'tansig','tansig','purelin'},'traingdm');
%  当前输入层权值和阈值 
inputWeights=net_1.IW{1,1} 
inputbias=net_1.b{1} 
%  当前网络层权值和阈值 
layerWeights=net_1.LW{2,1} 
layerbias=net_1.b{2} 
%  设置训练参数
net_1.trainParam.show = 50; 
net_1.trainParam.lr = 0.05; 
net_1.trainParam.mc = 0.9; 
net_1.trainParam.epochs = 20000; 
net_1.trainParam.goal = 1e-5; 
%  调用 TRAINGDM 算法训练 BP 网络
[net_1,tr]=train(net_1,D,age); 
%  对 BP 网络进行仿真
chinaAge = sim(net_1,china);
chinaAge=chinaAge.*10+60;
%输出
chinaAge



