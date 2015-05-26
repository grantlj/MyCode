
syms x y  a b c d e f g;

f1=sym('(x-a)^2+(y-b)^2=c^2');
f2=sym('(x-d)^2+(y-e)^2=f^2');

g=solve(f1,f2,x,y);
%½øÐÐ»¯¼ò
fx1=simple( g.x(1) )
fx2=simple( g.x(2) )