function output = codification(data, lengthData)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    sizeData = size(data);
    if (sizeData(1) == 1 && sizeData(1) < sizeData(2))
        data = data';
    end
    data = logical(data);
    ldpcEncoder = comm.LDPCEncoder;
    lengthMessage = 32400;
    from = 1;
    to = lengthMessage;
    output = [];
    tmp = lengthData;
    while tmp > 0
        if (to > length(data))
            difference = to - length(data);
            data = [data; zeros(difference, 1)];
        end
        encod = ldpcEncoder(data(from:to));
        release(ldpcEncoder);
        output = [output; encod];
        from = to + 1;
        to = to + lengthMessage;
        tmp = tmp - lengthMessage;
    end
    if (sizeData(1) == 1 && sizeData(1) < sizeData(2))
        output = output';
    end
end

