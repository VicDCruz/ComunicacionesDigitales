function [data, pilot] = demultiplexing(demappedData, symbol)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here
    pilot = [];
    data = [];

    % We have 3 cases--

    % (1)When symbol is in the 1st slot
    % (2)When symbol is in the 5th slot
    % (3)When symbol is neither in the 1st slot or 5th slot

    if(symbol==1)
        for pp=1:1:length(demappedData)
            if(mod(pp,6)==0)
                pilot = [pilot demappedData(pp)];
            else 
                data = [data demappedData(pp)];
            end
        end
    elseif(symbol==5)
        for pp=1:1:length(demappedData)
            if(mod(pp-3,6)==0)
                pilot = [pilot demappedData(pp)];
            else 
                data = [data demappedData(pp)];
            end
        end
    else
        data=demappedData;
    end 
end

