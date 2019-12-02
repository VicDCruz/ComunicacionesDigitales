function output = getSubcarriers(numSC, cpLen)
%GETSUBCARRIERS Obtener el numDC con base
% en el prefijo cíclico y el número de subcarriers
    ofdmMod = comm.OFDMModulator('FFTLength', numSC,...
        'CyclicPrefixLength', cpLen);
    ofdmDims = info(ofdmMod);
    output = ofdmDims.DataInputSize(1);
end

