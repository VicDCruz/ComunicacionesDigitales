function output = decodification(data, intrlvrInd)
%DECODIFICATION Decodificar datos de los turbo códigos
    turboDec = comm.TurboDecoder('InterleaverIndicesSource', 'Input port', ...
        'NumIterations', 4);
    output = turboDec(-data, intrlvrInd);
end

