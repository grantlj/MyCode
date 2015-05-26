clear
clc
syms a b c d e f g h i x y z;
f1=sym('(x-a)^2+(y-b)^2+z^2=c^2');
f2=sym('(x-d)^2+(y-e)^2+z^2=f^2');
f3=sym('(x-g)^2+(y-h)^2+z^2=i^2');
g=solve(f1,f2,f3,x,y,z);

fx=simple(g.x(1));
fy=simple(g.y(1));
fz=simple(g.z(1));


