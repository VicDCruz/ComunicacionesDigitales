function output = demodulationQPSK(data)
%DEMODULATIONQPSK Demodular los símbolos QPSK
    qpskDemod = comm.QPSKDemodulator('BitOutput', true);
    output = qpskDemod(data);
end

