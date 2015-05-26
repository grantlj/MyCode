function dy = fun_eq2( t,y )
%FUN_EQ2 Summary of this function goes here
%   Detailed explanation goes here
VS=340.3;
x2=sqrt(50366.7^2+13107.2^2);
dy=zeros(2,1);
dy(1)=2*VS*(x2-y(1))/sqrt((x2-y(1))^2+(t*VS-y(2))^2);
dy(2)=2*VS*(t*VS-y(2))/sqrt((x2-y(1))^2+(t*VS-y(2))^2);
end

