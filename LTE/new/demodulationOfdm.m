function output = demodulationOfdm(data, numSC, cpLen)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    ofdmDemod = comm.OFDMDemodulator('FFTLength',numSC,'CyclicPrefixLength',cpLen);
    output = ofdmDemod(data);
end

