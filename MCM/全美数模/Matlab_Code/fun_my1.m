function [ output_args ] = fun_my1( input_args )
%FUN_MY Summary of this function goes here
%   Detailed explanation goes here

output_args=log(1./4 .* input_args)./log( exp(1)/2 );
end

