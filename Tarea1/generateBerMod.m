function [EbNoVec, berEst, berTheory] = generateBerMod(M, type)
    k = log2(M);            % Bits per symbol
    EbNoVec = (-4:8)';      % Eb/No values (dB)
    numSymPerFrame = 100;

    berEst = zeros(size(EbNoVec));

    for n = 1:length(EbNoVec)
        % Convert Eb/No to SNR
        snrdB = EbNoVec(n) + 10*log10(k);
        % Reset the error and bit counters
        numErrs = 0;
        numBits = 0;

        while numErrs < 200 && numBits < 1e7
            % Generate binary data and convert to symbols
            dataIn = randi([0 1],numSymPerFrame,k);
            dataSym = bi2de(dataIn);

            % QAM modulate using 'Gray' symbol mapping
            txSig = qammod(dataSym,M);

            % Pass through AWGN channel
            rxSig = awgn(txSig,snrdB,'measured');

            % Demodulate the noisy signal
            rxSym = qamdemod(rxSig,M);
            % Convert received symbols to bits
            dataOut = de2bi(rxSym,k);

            % Calculate the number of bit errors
            nErrors = biterr(dataIn,dataOut);

            % Increment the error and bit counters
            numErrs = numErrs + nErrors;
            numBits = numBits + numSymPerFrame*k;
        end

        % Estimate the BER
        berEst(n) = numErrs/numBits;
    end

    if strcmp(type, 'qam')
        berTheory = berawgn(EbNoVec,'qam',M);
    else
        berTheory = berawgn(EbNoVec,'psk',M, 'nondiff');
    end
end

