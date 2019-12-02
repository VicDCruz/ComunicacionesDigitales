function output = modulationQPSK(data)
%MODULATIONQPSK Modular los datos con QPSK
    qpskMod = comm.QPSKModulator('BitInput',true);
    output = qpskMod(data);
end

