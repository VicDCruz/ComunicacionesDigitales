clc; close all; clear all;

SNRdB=-4:8;                                       %Signal to Noise Ratio in dB
SNR=10.^(SNRdB/10);                             %Signal to Noise Ratio in Linear Scale
Bit_Length=10^6;
BER_Simulated=zeros(1,length(SNRdB));

for k=1:length(SNR)
    x=(2*floor(2*rand(1,Bit_Length)))-1;
    y=(sqrt(SNR(k))*x)+randn(1,Bit_Length);
                                                                
    BER_Simulated(k)=length(find((y.*x)<0));
end
BER_Simulated=BER_Simulated/Bit_Length;
semilogy(SNRdB,BER_Simulated,'<');
hold on
semilogy(SNRdB,qfunc(sqrt(SNR)));
title('Prob. de bit en error en dif. val. de SNR')
grid


M = 4;
[EbNoVec, berEst, berTheory] = generateBerMod(M, 'psk');
semilogy(EbNoVec,berEst,'*')
hold on
semilogy(EbNoVec,berTheory)
grid
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')

for M = [16, 64]
    [EbNoVec, berEst, berTheory] = generateBerMod(M, 'qam');
    if M == 64
        semilogy(EbNoVec,berEst,'o')
    else
        semilogy(EbNoVec,berEst,'+')
    end
    hold on
    semilogy(EbNoVec,berTheory)
    grid
    xlabel('SNR (dB)')
    ylabel('Pb (BER)')
end

legend('BPSK - Estadistico', 'BPSK - Teórico', ...
    'QPSK - Estadistico', 'QPSK - Teórico', ...
    '16-QAM - Estadistico', 'QPKS - Teórico', ...
    '64-QAM - Estadistico', '64-QAM - Teórico'...
);