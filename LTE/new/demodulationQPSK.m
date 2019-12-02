function output = demodulationQPSK(data)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    qpskDemod = comm.QPSKDemodulator('BitOutput',true);
    output = qpskDemod(data);
end

