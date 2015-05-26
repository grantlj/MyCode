function [ allFileNameCell ] = fun_getAllFileName( dirAdress,fileType )
%获取一个文件夹下所有文件名字符串向量
%   一个变量时，输出所有文件名;第二个变量规定文件类型


allFileNameStruct=dir(dirAdress);
%检测是否要停止
if size(allFileNameStruct,1)==0
    allFileNameCell={};
    return
end
%清除文件夹
for i=1:size(allFileNameStruct,1)
    isD(i)=allFileNameStruct(i).isdir;
end
allFileNameStruct(isD)=[];

%检测是否要停止
if size(allFileNameStruct,1)==0
    allFileNameCell={};
    return
end


if nargin>1
    %保留需要的类型
    for i=1:size(allFileNameStruct,1)
        isType(i)=sum(strfind(allFileNameStruct(i).name,fileType))>0;
    end
    allFileNameStruct(~isType)=[];
end

%检测是否要停止
if size(allFileNameStruct,1)==0
    allFileNameCell={};
    return
end

%将文件名转入胞数组中
for i=1:size(allFileNameStruct,1)
    allFileNameCell{i}=allFileNameStruct(i).name;
end

end

