function yy = fun_deleteErrorData( x,y,v,error )
%删除 x y v 中error中指示位置的元素，返回一个三列的矩阵
yy=[x y v];
if isempty(error)
else
    for i=1:length(error)
        yy(i,:)=[];
    end
end
end

