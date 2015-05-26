
tar=mat;

for i=1:100000
    tar=tar*tar;
    v=sum(tar);
    for i=1:10
        tar(:,i)=tar(:,i)./v(i);
    end
end