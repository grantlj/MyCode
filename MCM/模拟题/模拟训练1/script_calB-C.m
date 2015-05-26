clear
data=[4 1 1 1 2 ; 5 1 1 1 2; 3 1 3 2 2 ;1 3 2 4 1;1 5 3 4 2 ];

for i=1:5
    mat(:,:,i)=fun_buildJudgMat(data(i,:));
    [vec(:,i) res(:,i)]=fun_AHP(mat(:,:,i));
end
