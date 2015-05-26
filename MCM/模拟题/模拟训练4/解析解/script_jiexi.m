
syms x y
f1=sym('Dx=5*(1-x)/sqrt((1-x)^2+(t-y)^2)');
f2=sym('Dy=5*(t-y)/sqrt((1-x)^2+(t-y)^2)');

g=dsolve(f1,f2)
