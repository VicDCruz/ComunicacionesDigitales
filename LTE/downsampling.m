function output = downsampling(symbols)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
    lengthSymbols = length(symbols);
    output = zeros(lengthSymbols / 4, 1);
    for x = 0:1:length(output)- 1
        output(x + 1, 1) = symbols(4 * x + 1, 1);
    end
end

