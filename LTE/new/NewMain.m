clear all; close all; clc;

%% Data
disp('Cargando imagen')
% data = logical(randi([0 1], 32400, 1));
data = readImage('example.jpg')';
intrlvrInd = randperm(length(data));
encodedData = codification(data, intrlvrInd);

%% Init variables
disp('Inicializando variables')
M = 4;                 % Modulation alphabet
k = log2(M);           % Bits/symbol
numSC = 128;           % Number of OFDM subcarriers
cpLen = 32;            % OFDM cyclic prefix length
maxBitErrors = 100;    % Maximum number of bit errors
maxNumBits = 1e7;      % Maximum number of bits transmitted
numDC = getSubcarriers(numSC, cpLen);
frameSize = k * numDC;
EbNoVec = (0:10)';
snrVec = EbNoVec + 10*log10(k) + 10*log10(numDC/numSC);
% snrVec = [0.25, 0.5, 0.75, 1.0, 1.25, 7];
totalFrames = ceil(length(encodedData) / frameSize);

lengthEncodedData = length(encodedData);
if ((totalFrames * frameSize) > lengthEncodedData)
    encodedData = [encodedData; zeros((totalFrames * frameSize) - length(encodedData), 1)];
end

%% Init BER
errorRate = comm.ErrorRate('ResetInputPort',true);
berVec = zeros(length(snrVec),3);
errorStats = zeros(1,3);

for x = 1:length(snrVec)
    snr = snrVec(x);
    from = 1; to = frameSize;
    receivedData = [];
    
    %% Envio de tramas
    for frameCount = 1:totalFrames
        contentTx = encodedData(from:to);
        from = to + 1;
        to = to + frameSize;
        
        %% TX
        modulatedData = modulationQPSK(contentTx);
        txSig = modulationOfdm(modulatedData, numSC, cpLen);
        
        %% Ruido
        % channelData = awgn(txSig, snr, 'measured');
        channel = comm.AWGNChannel('NoiseMethod','Variance', ...
            'VarianceSource','Input port');
        powerDB = 10*log10(var(txSig));
        noiseVar = 10.^(0.1*(powerDB - snr));
        channelData = channel(txSig,noiseVar);
        
        %% RX
        rxSig = demodulationOfdm(channelData, numSC, cpLen);
        demodulatedData = demodulationQPSK(rxSig);
        receivedData = [receivedData; demodulatedData];
        
        %% Calc Ber
        errorStats = errorRate(contentTx, demodulatedData,0);
    end
    
    %% Calc BER
    berVec(x,:) = errorStats;                         % Save BER data
    errorStats = errorRate(contentTx, demodulatedData, 1);         % Reset the error rate calculator

    %% Creando imagen p/c SNR
    receivedImage = decodification(receivedData(1:lengthEncodedData), intrlvrInd);
    writeImage(~receivedImage(1:length(data)));
end

printBer(EbNoVec, M, berVec)