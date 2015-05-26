function [ G ] = gaussian( Input ,sigma)
%GAUSSIAN Summary of this function goes here
%   Detailed explanation goes here

G=exp(-(Input.^2)./( 2.* sigma.*sigma) )./( sqrt(2*3.14).*sigma );

end

