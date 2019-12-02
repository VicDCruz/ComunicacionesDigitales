function output = demodulationOfdm(data, numSC, cpLen)
%DEMODULATIONOFDM Demodular los símbolos de OFDM con el número de
% subcarriers
    ofdmDemod = comm.OFDMDemodulator('FFTLength', numSC, 'CyclicPrefixLength', cpLen);
    output = ofdmDemod(data);
end

