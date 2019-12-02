clear all; close all; clc;

%% Selecci�n de ruido
noiseType = input('Tipo de ruido, AWGN(0) / Rayleigh(1): ', 's');
dataType = input('Tipo de dato, Imagen(0) / Bits random(1): ', 's');

%% Data
disp('Cargando datos')
if (dataType == '1')
    data = randi([0 1], 160000, 1);
else
    path = input('Nombre del archivo (Enter - default): ', 's');
    if (path == "")
        path = 'peppers.png';
    end
    data = readImage(path)';
end
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
errorRateDemod = comm.ErrorRate('ResetInputPort',true);
berDemod = zeros(length(snrVec),3);
errorStatsDemod = zeros(1,3);

errorRateMod = comm.ErrorRate('ResetInputPort',true);
berMod = zeros(length(snrVec),3);
errorStatsMod = zeros(1,3);

errorRateCod = comm.ErrorRate('ResetInputPort',true);
berCod = zeros(length(snrVec),3);
errorStatsCod = zeros(1,3);

image = writeImage(data);
figure
subplot(3,4,1); imshow(image);
title('Imagen original'); hold on

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
        if (noiseType == '0')
            channel = comm.AWGNChannel('NoiseMethod','Variance', ...
                'VarianceSource','Input port');
            powerDB = 10*log10(var(txSig));
            noiseVar = 10.^(0.1*(powerDB - snr));
            channelData = channel(txSig, noiseVar);
        else
            channelData = rayleigh(txSig);
        end
        
        %% RX
        rxSig = demodulationOfdm(channelData, numSC, cpLen);
        demodulatedData = demodulationQPSK(rxSig);
        receivedData = [receivedData; demodulatedData];
        
        %% Calc Ber
        errorStatsDemod = errorRateDemod(contentTx, demodulatedData,0);
    end
    
    %% Calc BER
    berDemod(x,:) = errorStatsDemod;                         % Save BER data
    errorStatsDemod = errorRateDemod(contentTx, demodulatedData, 1);         % Reset the error rate calculator

    %% Creando imagen p/c SNR
    receivedImage = decodification(receivedData(1:lengthEncodedData), intrlvrInd);
    image = writeImage(~receivedImage(1:length(data)));
    subplot(3,4,x+1); imshow(image);
    titulo = strcat('Valor de SNR: ', num2str(snr)); title(titulo);
    hold on
    
end

printBer(EbNoVec, M, berDemod)
