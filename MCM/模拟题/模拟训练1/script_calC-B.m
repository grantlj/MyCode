clear
data=[6 7 4 2 1 ;4 3 1 6 9;5 5 6 3 1; 2 2 1 3 5 ; 3 4 1 2 6 ];

for i=1:5
    mat(:,:,i)=fun_buildJudgMat(data(i,:));
    if i==2||i==4
        mat(:,:,i)=1./mat(:,:,i);
    end
    [vec(:,i) res(:,i)]=fun_AHP(mat(:,:,i));
end
