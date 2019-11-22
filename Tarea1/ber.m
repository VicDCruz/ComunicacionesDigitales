close all; clc; clear all;
for M = [2, 4]
    for y = [1, 5, 30, 40, 50, 80]
        data = randi([0, M-1], 1000, 1);
        txSig = pskmod(data, M, pi/M);
        rxSig = awgn(txSig, y);
        scatterplot(rxSig);
        if M == 2
            title('BPSK')
        else
            title('QPSK')
        end
    end
end
for M = [16, 64]
    for y = [1, 5, 30, 40, 50, 80]
        data = randi([0, M-1], 1000, 1);
        txSig = qammod(data, M);
        rxSig = awgn(txSig, y);
        scatterplot(rxSig);
        if M == 16
            title('16-QAM')
        else
            title('64-QAM')
        end
    end
end

