function [ vec,res] = fun_AHP( val )
%res ���� ��max CI CR
%   Detailed explanation goes here
RI=[0 0 0.58 0.9 1.12 1.24 1.32 1.41 1.45 1.49 1.51 1.48];
n=size(val,1);
%����������V������ֵD
[v, d]=eig(val);
v=real(v);
d=real(d);
%�õ���һ���ı���
d=sum(d);
[maxv ,index]=max(d);
vec=v(:,index);
vec=vec./sum(vec);

%һ���Լ���
CI=(maxv-n)./(n-1);
CR=CI./RI(n);

res=[maxv ;CI ; CR ];

end

