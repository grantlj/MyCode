function boolean = fun_st( x1,x2,demand,Q)
%Լ�������ĺ��� �����Ϊ��1��·�� 2��·�� ���������� ����������� ���г�����

boolean=1;
n=size(demand,1);
demand=[demand;0];
%����·�ĳ���
num(1)=sum(x1>0);
num(2)=sum(x2>0);

%Ϊ��ѭ�����������
x=[ x1 zeros(1,n+2-num(1)) ; x2 zeros(1,n+2-num(2))];

for i=1:2
    %����ǰ������
    r=0;
    for j=1:num(i)
        r=r-demand(x(i,j));
        %���㳵������
        if r<0||r>Q
            boolean=0;
            return;
        end
    end
    %��·�ĺ�Ϊ0;
    if r~=0
        boolean=0;
        return;
    end
end



end

