function H = fun_regress( val )
%遍历所有AOM区域中的点，给出相应的数据
%用于判断最可能是源的点
save=val;
Y=val(:,4);

for i=1:size(val,1)
    
    val(:,1)=(val(:,1) - val(i,1) ).^2./4;
    val(:,2)=(val(:,2) - val(i,2) ).^2./4;
    val(:,3)=(val(:,3) - val(i,3) ).^2./4;
    X=[ones( size(val,1),1) val(:,[1 2 3])];
    [b,bint,r,rint,stats]=regress(Y ,X , 0.2);
    H(i,:)=[   save(i,:) stats ];
end

end

