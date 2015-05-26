function isIntersect = fun_isIntersect( radarOne,radarTwo)
%FUN_ISINTERSECT Summary of this function goes here
%   Detailed explanation goes here
d=sqrt( (radarOne(1)-radarTwo(1)).^2+(radarOne(2)-radarTwo(2)).^2 );
if d<=radarOne(3)+radarTwo(3)
    isIntersect=1;
else
    isIntersect=0;
end
end

