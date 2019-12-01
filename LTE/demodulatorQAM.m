function output = demodulatorQAM(data)
%UNTITLED17 Summary of this function goes here
%   Detailed explanation goes here
    output = zeros(length(data), 4);
    data = data.*sqrt(10);
    for i= 1:length(data)
        realPart(i) = real(data(i));
        imaginaryPart(i) = imag(data(i));
        if (realPart(i) > 0)&&(realPart(i) < 2)
            output(i,1) = 1;
            output(i,3) = 0;
        end
        if (realPart(i) < 0) && (realPart(i) > -2)
            output(i, 1) = 0;
            output(i, 3) = 0; 
        end
        if (realPart(i) > 2)
            output(i, 1) = 1;
            output(i, 3) = 1; 
        end
        if (realPart(i) < -2)
            output(i, 1)=0;
            output(i, 3)=1;
        end
        if (imaginaryPart(i) > 0) && (imaginaryPart(i) < 2)
            output(i, 2) = 1;
            output(i, 4) = 0;
        end
        if (imaginaryPart(i) < 0) && (imaginaryPart(i) > -2)
            output(i, 2) = 0;
            output(i, 4) = 0; 
        end
        if (imaginaryPart(i) > 2)
            output(i, 2) = 1;
            output(i, 4) = 1; 
        end
        if (imaginaryPart(i) < -2)
            output(i, 2) = 0;
            output(i, 4) = 1;
        end
    end
    output = reshape(output', 1, length(data) * 4);
end

