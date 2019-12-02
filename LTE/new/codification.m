function output = codification(data, intrlvrInd)
%CODIFICATION Obtener la codificación de los datos por medio de 
% los turbo códigos
    turboEnc = comm.TurboEncoder('InterleaverIndicesSource', 'Input port');
    output = turboEnc(data, intrlvrInd);
end

