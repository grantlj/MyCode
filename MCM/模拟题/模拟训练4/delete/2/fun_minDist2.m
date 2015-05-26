function [ minVal,posi ] = fun_minDist2( targetLocation,radarInfo )
%FUN_MINDIST2 Summary of this function goes here
%   Detailed explanation goes here
fy=sym('-(- a^2 + 2*x*a - b^2 + c^2 + d^2 - 2*x*d + e^2 - f^2)/(2*(b - e))');
fz=sym('(- a^4 + 4*a^3*x - 2*a^2*b^2 + 4*a^2*b*e + 2*a^2*c^2 + 2*a^2*d^2 - 4*a^2*d*x - 2*a^2*e^2 - 2*a^2*f^2 - 4*a^2*x^2 + 4*a*b^2*x - 8*a*b*e*x - 4*a*c^2*x - 4*a*d^2*x + 8*a*d*x^2 + 4*a*e^2*x + 4*a*f^2*x - b^4 + 4*b^3*e + 2*b^2*c^2 - 2*b^2*d^2 + 4*b^2*d*x - 6*b^2*e^2 + 2*b^2*f^2 - 4*b^2*x^2 - 4*b*c^2*e + 4*b*d^2*e - 8*b*d*e*x + 4*b*e^3 - 4*b*e*f^2 + 8*b*e*x^2 - c^4 - 2*c^2*d^2 + 4*c^2*d*x + 2*c^2*e^2 + 2*c^2*f^2 - d^4 + 4*d^3*x - 2*d^2*e^2 + 2*d^2*f^2 - 4*d^2*x^2 + 4*d*e^2*x - 4*d*f^2*x - e^4 + 2*e^2*f^2 - 4*e^2*x^2 - f^4)^(1/2)/(2*(b - e))');
%代入数值
fy=subs(fy,{'a','b','c','d','e','f'},{radarInfo(1),radarInfo(2),radarInfo(3),radarInfo(4),radarInfo(5),radarInfo(6)});
fz=subs(fz,{'a','b','c','d','e','f'},{radarInfo(1),radarInfo(2),radarInfo(3),radarInfo(4),radarInfo(5),radarInfo(6)});

fx1=sym('(a*b^2 - a*c^2 - a*d^2 - a^2*d + a*e^2 + b^2*d + b*((a^2 - 2*a*d + b^2 - 2*b*e - c^2 + 2*c*f + d^2 + e^2 - f^2)*(- a^2 + 2*a*d - b^2 + 2*b*e + c^2 + 2*c*f - d^2 - e^2 + f^2))^(1/2) + a*f^2 + c^2*d + d*e^2 - e*((a^2 - 2*a*d + b^2 - 2*b*e - c^2 + 2*c*f + d^2 + e^2 - f^2)*(- a^2 + 2*a*d - b^2 + 2*b*e + c^2 + 2*c*f - d^2 - e^2 + f^2))^(1/2) - d*f^2 + a^3 + d^3 - 2*a*b*e - 2*b*d*e)/(2*(a^2 - 2*a*d + b^2 - 2*b*e + d^2 + e^2))');
fx2=sym('(a*b^2 - a*c^2 - a*d^2 - a^2*d + a*e^2 + b^2*d - b*((a^2 - 2*a*d + b^2 - 2*b*e - c^2 + 2*c*f + d^2 + e^2 - f^2)*(- a^2 + 2*a*d - b^2 + 2*b*e + c^2 + 2*c*f - d^2 - e^2 + f^2))^(1/2) + a*f^2 + c^2*d + d*e^2 + e*((a^2 - 2*a*d + b^2 - 2*b*e - c^2 + 2*c*f + d^2 + e^2 - f^2)*(- a^2 + 2*a*d - b^2 + 2*b*e + c^2 + 2*c*f - d^2 - e^2 + f^2))^(1/2) - d*f^2 + a^3 + d^3 - 2*a*b*e - 2*b*d*e)/(2*(a^2 - 2*a*d + b^2 - 2*b*e + d^2 + e^2))');
x1=subs(fx1,{'a','b','c','d','e','f'},{radarInfo(1),radarInfo(2),radarInfo(3),radarInfo(4),radarInfo(5),radarInfo(6)});
x2=subs(fx2,{'a','b','c','d','e','f'},{radarInfo(1),radarInfo(2),radarInfo(3),radarInfo(4),radarInfo(5),radarInfo(6)});
%求x范围
minX=min(x1,x2);
dX=abs(x1-x2);

x=[0:(dX./10000):dX]+minX;
y=subs(fy,{'x'},{x});
z=subs(fz,{'x'},{x});
    


d=abs(targetLocation(3)-sqrt((x-targetLocation(1)).^2+(y-targetLocation(2)).^2+z.^2));
[minVal,index]=min(d);
posi=[x(index) y(index) z(index)];


end

