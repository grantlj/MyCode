function [ vec,res] = fun_AHP( val )
%res 包含 入max CI CR
%   Detailed explanation goes here
RI=[0 0 0.58 0.9 1.12 1.24 1.32 1.41 1.45 1.49 1.51 1.48];
n=size(val,1);
%求特征向量V和特征值D
[v, d]=eig(val);
v=real(v);
d=real(d);
%得到归一化的比重
d=sum(d);
[maxv ,index]=max(d);
vec=v(:,index);
vec=vec./sum(vec);

%一致性检验
CI=(maxv-n)./(n-1);
CR=CI./RI(n);

res=[maxv ;CI ; CR ];

end

