function [ H ] = fun_interp( val,altitude )
%����griddata��ʹ��cubic��ֵ
[Xq Yq]=meshgrid(1:max(val(:,1)),1:max(val(:,2)));
H=griddata(val(:,1),val(:,2),val(:,3) ,Xq,Yq,'cubic' );
end
 
