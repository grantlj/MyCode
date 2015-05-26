function out = fun_DOM( mat )
%FUN_DOM Summary of this function goes here
%   Detailed explanation goes here
a=[283.930000000000,3.70000000000000,0,2.77000000000000,21.3711079999998,513.264600000000,0.0200000000000000;];
b=[339.580000000000,8.88000000000000,902.400000000000,50,496.473264000000,5328.45000000000,2.90000000000000;];
%去掉上下界

k=[1 1/2 1/3 1 1/2 1 1 ];
for i=1:size(mat,2)
    mat( mat(:,i)<=a(i) ,i)=0;
    mat( mat(:,i)>=b(i) ,i)=1;
    mat(  mat(:,i)>a(i)&mat(:,i)<b(i),i )= ((mat(mat(:,i)>a(i)&mat(:,i)<b(i),i)-a(i))./(b(i)-a(i))).^k(i);
end


out=mat;

end

