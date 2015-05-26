function E = fun_obj( x1,x2,demand,timeMat )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
x1=[31 x1 31];
x2=[31 x2 31];
n=size(demand,1);
demand=[demand;0];

num(1)=sum(x1>0);
num(2)=sum(x2>0);

t=zeros(1,2);

for i=1:num(1)-1;
     t(1)=t(1)+timeMat( x1(i) , x1(i+1) )+abs(demand(x1(i)));
 end
 for i=1:num(2)-1;
     t(2)=t(2)+timeMat( x2(i) , x2(i+1) )+abs(demand(x2(i)));
 end

 
E=max(t(1),t(2));

end

