function output = modulatorQAM(data)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    temp = zeros(ceil(length(data) / 4), 4);
    sizeMatrix = size(temp);
    dataCounter = 1;
    m = 1;
    while m <= sizeMatrix(1) && dataCounter < length(data)
        n = 1;
        while n <= sizeMatrix(2) && dataCounter < length(data)
            temp(m, n) = data(dataCounter);
            dataCounter = dataCounter + 1;
            n= n + 1;
        end
        m = m + 1;
    end
    output = zeros(sizeMatrix(1), 1);
    for m = 1:1:sizeMatrix(1)
        if (temp(m,1) == 0 && temp(m,3) == 0)
            output(m) = output(m) - 1;
        end
        if (temp(m,1) == 0 && temp(m,3) == 1)
            output(m) = output(m) - 3;
        end
        if (temp(m,1) == 1 && temp(m,3) == 0)
            output(m)= output(m) + 1;
        end
        if (temp(m,1)==1 && temp(m,3) == 1)
            output(m) = output(m) + 3;
        end
        if (temp(m,2)==0 && temp(m,4) == 0)
            output(m) = output(m) - 1i;
        end
        if (temp(m,2)==0 && temp(m,4) == 1)
            output(m) = output(m) - 3i;
        end
        if (temp(m,2)==1 && temp(m,4) == 0)
            output(m) = output(m) + 1i;
        end
        if (temp(m,2)==1 && temp(m,4) == 1)
            output(m) = output(m) + 3i;
        end
    end
end

