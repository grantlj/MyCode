
syms x y z a b c d e f g;

f1=sym('(x-a)^2+(y-b)^2+z^2=c^2');
f2=sym('(x-d)^2+(y-e)^2+z^2=f^2');

g=solve(f1,f2,y,z);
%½øÐÐ»¯¼ò
fy_x=simple( g.y(1) )
fz_x=simple( g.z(1) )

h=solve(f1,f2,x,z);
fx_y=simple( h.x(1) )
fz_y=simple( h.z(1) )