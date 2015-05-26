function [ means,vars ] = fun_means_vars(val,use  )
%用于求每个区域每个元素的平均值和方差
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

