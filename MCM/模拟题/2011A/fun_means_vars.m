function [ means,vars ] = fun_means_vars(val,use  )
%������ÿ������ÿ��Ԫ�ص�ƽ��ֵ�ͷ���
means=[];
vars=[];
for i=1:5
    useFlag=(use==i);
for j=1:size(val,3)
    temp=val(:,:,j);
    temp=temp(useFlag);
    temp(isnan(temp))=[];
    tempMeans(j)=mean(temp);
    tempVars(j)=var(temp);
end
means=[means ; tempMeans];
vars=[vars ; tempVars ];
end

