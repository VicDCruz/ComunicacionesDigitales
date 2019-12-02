function output = getSubcarriers(numSC, cpLen)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    ofdmMod = comm.OFDMModulator('FFTLength' ,numSC, 'CyclicPrefixLength', cpLen);
    ofdmDims = info(ofdmMod)
    output = ofdmDims.DataInputSize(1);
end

