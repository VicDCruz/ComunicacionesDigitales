function output = rayleigh(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    h = randn(length(data), 1) + 1i * randn(length(data), 1);
    output = h .* data;
end

