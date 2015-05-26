function [ onRoadMat ,nodeInfoMat ] = fun_refreshRent( onRoadMat ,nodeInfoMat )
%1∑÷÷”À¢–¬onRoadMat°¢val
n=size(onRoadMat,2);
onRoadMat(3,:)=onRoadMat(3,:)-1;
temp=onRoadMat(3,:);
arriveInd=(temp==0);
val=nodeInfoMat(1,:)';

% for i=1:n
%     if arriveInd(i)==1
%         val(onRoadMat(2,i))=val(onRoadMat(2,i))+1;
%     end
% end
val(onRoadMat(2,arriveInd))=val(onRoadMat(2,arriveInd))+1;
onRoadMat(:,arriveInd)=[];

nodeInfoMat(1,:)=val';

end

