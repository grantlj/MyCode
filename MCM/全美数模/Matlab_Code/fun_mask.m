function [ out ] = fun_mask( in )
%FUN_MASK Summary of this function goes here
%   Detailed explanation goes here
if in<=9
    out=log(1./4 .* in)./log( exp(1)/2 );
else
    out= 2.6427.* (exp(1)/2) .^( 9 - in );
    
end
end

