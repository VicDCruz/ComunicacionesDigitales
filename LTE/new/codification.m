function output = codification(data, intrlvrInd)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    turboEnc = comm.TurboEncoder('InterleaverIndicesSource','Input port');
    output = turboEnc(data, intrlvrInd);
%     sizeData = size(data);
%     if (sizeData(1) == 1 && sizeData(1) < sizeData(2))
%         data = data';
%     end
%     ldpcEncoder = comm.LDPCEncoder;
%     data = logical(data);
%     lengthMessage = 32400;
%     from = 1;
%     to = lengthMessage;
%     output = [];
%     tmp = lengthData;
%     while tmp > 0
%         if (to > length(data))
%             difference = to - length(data);
%             data = [data; zeros(difference, 1)];
%         end
%         encod = ldpcEncoder(data(from:to));
%         release(ldpcEncoder);
%         output = [output; encod];
%         from = to + 1;
%         to = to + lengthMessage;
%         tmp = tmp - lengthMessage;
%     end
end

