function output = modulationOfdm(data, numSC, cpLen)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    ofdmMod = comm.OFDMModulator('FFTLength', numSC, 'CyclicPrefixLength', cpLen);
    output = ofdmMod(data);
end

