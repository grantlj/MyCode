function yy = fun_deleteErrorData( x,y,v,error )
%ɾ�� x y v ��error��ָʾλ�õ�Ԫ�أ�����һ�����еľ���
yy=[x y v];
if isempty(error)
else
    for i=1:length(error)
        yy(i,:)=[];
    end
end
end

