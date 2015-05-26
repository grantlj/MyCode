function [ allFileNameCell ] = fun_getAllFileName( dirAdress,fileType )
%��ȡһ���ļ����������ļ����ַ�������
%   һ������ʱ����������ļ���;�ڶ��������涨�ļ�����


allFileNameStruct=dir(dirAdress);
%����Ƿ�Ҫֹͣ
if size(allFileNameStruct,1)==0
    allFileNameCell={};
    return
end
%����ļ���
for i=1:size(allFileNameStruct,1)
    isD(i)=allFileNameStruct(i).isdir;
end
allFileNameStruct(isD)=[];

%����Ƿ�Ҫֹͣ
if size(allFileNameStruct,1)==0
    allFileNameCell={};
    return
end


if nargin>1
    %������Ҫ������
    for i=1:size(allFileNameStruct,1)
        isType(i)=sum(strfind(allFileNameStruct(i).name,fileType))>0;
    end
    allFileNameStruct(~isType)=[];
end

%����Ƿ�Ҫֹͣ
if size(allFileNameStruct,1)==0
    allFileNameCell={};
    return
end

%���ļ���ת���������
for i=1:size(allFileNameStruct,1)
    allFileNameCell{i}=allFileNameStruct(i).name;
end

end

