% Image=imread('region.jpg');
% imshow(Image);
% anss=ginput


%¸ßË¹º¯Êı
% G=gaussian(-2:2,1);


input1=0.1: 0.1 :9;
input2=9.01:0.1:26;
output1=fun_my1(input1);
output2=fun_my2(input2);
output=[output1 output2];
plot ( [ input1 input2],[output1 output2]  )

mat= zeros(14,14);
for i=0:13
    for j = 0:13
        mat( i+1,j +1)= fun_mask( sqrt( i.^2 +j ^ 2 ) );
    end
end





