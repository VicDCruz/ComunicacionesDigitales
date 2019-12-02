function output = modulationOfdm(data, numSC, cpLen)
%MODULATIONOFDM Con respecto al largo de CP y el número de 
% subcarriers disponibles, obtenemos la modulación OFDM
% de los datos
    ofdmMod = comm.OFDMModulator('FFTLength', numSC,...
        'CyclicPrefixLength', cpLen);
    output = ofdmMod(data);
end

