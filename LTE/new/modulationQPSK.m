function output = modulationQPSK(data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    qpskMod = comm.QPSKModulator('BitInput',true);
    output = qpskMod(data);
end

