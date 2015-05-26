function dy = fun_eq( t,y )
%FUN_EQ2 Summary of this function goes here
%   Detailed explanation goes here
VS=340.3;
x23=50366.7;
dy=zeros(2,1);
dy(1)=2*VS*(x23-y(1))/sqrt((x23-y(1))^2+(t*VS-y(2))^2);
dy(2)=2*VS*(t*VS-y(2))/sqrt((x23-y(1))^2+(t*VS-y(2))^2);
end

