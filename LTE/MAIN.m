%% Principal - Simulación
%% Inicializando variables
clc;
clear all;
close all;

choice = input('Origen de datos: Aleatorio (1), Imagen (2) - ');
channelType = input('Tipo de canal: AWGN (0), Rayleigh (1) - ');

if(choice==1)
    disp('Número de bits: 160,000');
    bitsLength = 160000;
    data = randi([0, 1], 1, bitsLength);
end
if(choice==2)
    path = input('Introduce la ruta del archivo - ', 's');
    data = readImage(path);
end
lengthData = length(data);

%% Codificacion LDPC
% data = codification(data, length(data));

N = 512; % Num de subcarriers, tamaño de FFT
SNR = [-10 -5 -2.5 0 2.5 5 7.5 10 12.5 15 20 25 ];
count = 0;

%% Trama de LTE
frameSpace = 20; 
slotSymbols = 7;
r = 0;

%% Imprimiendo resultados (1)
disp('Antes de transmitir');
toPrint = input('Datos en el dominio del tiempo y la frecuencia (S / N) - ', 's');
if (toPrint == 'S' || toPrint == 's')
    from = ceil(rand() * lengthData / 2) + 1;
    to = floor(from + lengthData * 0.30);
    figure();
    subplot(2,1,1); timeDomain(data(from:to), 'B', 'Responsa en Tiempo');
    subplot(2,1,2); frequencyDomain(data(from:to), 'B', 'Respuesta en Frecuencia');
end

%% Señal piloto (QPSK)
% Configuración de la trama
Nc = 1600;
Ncp = 1; %for normal CP
x1 = zeros(1,1701);
x2 = zeros(1,1701);
c = zeros(1,101);
temp_matrix = zeros(1,50);
pilotMatrix = [];
x1(1) = 1;% Intializing the first m-sequence with x(0)=1 (3gpp pg98)
b = [];
cellId = 1;

for slotNumber = 1:40 % slotNumber - slot number within a radio frame
    for m = 1:3:4 % m - OFDM symbol number within the slot, first and fifth slots.
        cInit = power(2, 10) * (7 * (slotNumber + 1) + m + 1) * (2 * cellId + 1) + 2 * cellId + Ncp;
        b = de2bi(cInit); % decimal to binary vector

        for x = length(b):-1:1
            x2(x) = b(x);
        end
        for j = 1:1670
            x1(j + 31) = mod(x1(j + 3) + x1(j), 2);
        end
        for k = 1:1670
            x2(k + 31) = mod(x2(k + 3) + x2(k + 2) + x2(k + 1) + x2(k), 2);
        end
        for l = 1:101
            c(l) = mod(x1(l + Nc) + x2(l + Nc), 2);
        end
        % Modulación de la señal piloto: QPSK
        pilotSymbol = modulatorQPSK(c);
        m = numel(pilotSymbol);
    end
    pilotMatrix = [pilotMatrix, pilotSymbol];
end

%% Imprimiendo resultados (2)
disp('Señal piloto')
toPrint = input('Dominio del Tiempo y Freq y constelación QPSK (S / N) - ', 's');
if (toPrint == 'S' || toPrint == 's')
    from = floor(rand() * length(pilotMatrix) * 0.90) + 1;
    to = from + 100;
    figure;
    subplot(2, 1, 1);
    timeDomain(real(pilotMatrix(from:to)), 'B', 'Resp en T de 100 muestras QPSK del piloto');
    hold on;
    timeDomain(imag(pilotMatrix(from:to)), 'R', 'Resp en T de 100 muestras QPSK del piloto');
    legend('Real', 'Imaginario');
    subplot(2, 1, 2);
    frequencyDomain(pilotMatrix(from:to), 'B', 'Resp en F de 100 muestras QPSK del piloto');

    figure;
    scatter(real(pilotMatrix), imag(pilotMatrix));
    xlabel('Fase');
    ylabel('Cuadratura');
    title('Constelación de los símbolos del piloto')
end

%% Modulación (16-QAM)
dataCounter = 1;
pilotCounter = 1;
for slot = 1:frameSpace
    for symbol = 1:slotSymbols
        % Taking the first 1200 data bits and modulating it using QAM
        % In this case symbol data is present in 300 carriers
        if (rem(symbol - 1, 4) ~= 0)
            dataSymbol = modulatorQAM(data(dataCounter:(dataCounter + 1199)));
            dataCounter = dataCounter + 1200;

        % In this case symbol data is present in 250 carriers and hence 
        % we modulate the first 1000 bits only %
        else
            dataSymbol = modulatorQAM(data(dataCounter:(dataCounter + 999)));
            dataCounter = dataCounter + 1000;
        end
        
        %% Imprimiendo resultados (3)
        if (count == 0)
            disp('Modulación 16-QAM')
            toPrint = input('Dominio del Tiempo y Freq y constelación 16-QAM de muestras de datos (S / N) - ', 's');
        end
        if (toPrint == 'S' || toPrint == 's')
            if symbol == 1 && slot == 1
                from = ceil(rand() * length(dataSymbol) * 0.60) + 1;
                to = from + 100;
                figure;
                subplot(2, 1, 1);
                timeDomain(real(dataSymbol(from:to)), 'B', 'Resp en T de 100 muestras 16-QAM');
                hold on;
                timeDomain(imag(dataSymbol(from:to)), 'R', 'Resp en T de 100 muestras 16-QAM');
                legend('Real', 'Imaginario');
                subplot(2, 1, 2);
                frequencyDomain(dataSymbol(from:to), 'B', 'Resp en F de 100 muestras 16-QAM');
            end
            
           % Generating Constellation Plot
            if slot == 1 && symbol == 1
                 figure;
                 scatter(real(dataSymbol), imag(dataSymbol));
                 xlabel('Fase');
                 ylabel('Cuadratura');
                 title('Constelación de Modulación 16-QAM');
            end
        end

        %% Multiplexaje de datos y piloto
        if (rem(symbol - 1, 4) ~= 0)
            multiplexedData = multiplexing(dataSymbol, [], symbol); % Sin matriz piloto
        else
            multiplexedData = multiplexing(dataSymbol, pilotMatrix(pilotCounter:(pilotCounter + 49)), symbol);
            pilotCounter = pilotCounter + 50;
        end
        
        %% Mapeo de subcarriers
        mappedData = zeros(512, 1);
        subcarrierIndex = [-150:-1 1:150]; % 300 subcarriers utiles desde -150 hasta 150 para que DC(carrier) = 0
        for x = 1:300
            mappedData(subcarrierIndex(x) + 512 / 2 + 1) = multiplexedData(x);
        end
        
        %% IFFT
        mappedData = fftshift(mappedData);
        ifftData = ifft(mappedData, 512);
        
        %% Imprimiendo resultados (4)
        if (count == 0)
            disp('IFFT')
            toPrint = input('Resultado de IFFT (S / N) - ', 's');
        end
        if (toPrint == 'S' || toPrint == 's')
            if (slot==1 && symbol==1)
                from = floor(rand() * length(ifftData) * 0.80) + 1;
                to = from + 100;
                figure;
                subplot(2,1,1);
                timeDomain(real(ifftData(from:to)), 'B', 'Output of the IFFT for first 100 carriers(real)');
                hold on;
                timeDomain(imag(ifftData(from:to)), 'R', 'Output of the IFFT for first 100 carriers(imag)');
                legend('Real', 'Imaginario');
                subplot(2,1,2);
                frequencyDomain(ifftData(from:to), 'B', 'Frequency response of IFFT');
            end
        end
        
        %% Prefijo ciclico (CP)
        sequenceCP = addCP(ifftData);
        
        %% Imprimiendo resultados (5)
        if (count == 0)
            disp('Prefijo ciclico')
            toPrint = input('Resultado de Prefijo ciclico (S / N) - ', 's');
        end
        if (toPrint == 'S' || toPrint == 's')
            if (slot==1 && symbol==1)
                figure;
                plot(1:10);
                zoom on
                sequenceCPZoom = [zeros(36, 1); sequenceCP];
                timeDomain(sequenceCPZoom(1:36), 'W', 'Resp en T de CP');
                hold on;
                timeDomain(sequenceCPZoom(37:572), 'R', 'Resp en T de CP');
                hold on;
                timeDomain(sequenceCP(1:36), 'B', 'Time response of the CP');
                legend('', 'Without Cyclic Prefix', 'Cyclic Prefix', 'Location', 'SouthOutside');
            end
        end
        
        %% Muestreo cada 4 bits
        upsampledData = zeros(1, length(sequenceCP) * 4);
        for x = 0:1:(length(sequenceCP) - 1)
            upsampledData(1, 4 * x + 1) = sequenceCP(x + 1);
        end
        
        %% Imprimiendo resultados (6)
        if (count == 0)
            disp('Muestreo')
            toPrint = input('Resultado de Muestreo (S / N) - ', 's');
        end
        if (toPrint == 'S' || toPrint == 's')
            if (slot==1 && symbol==1)
                figure;
                subplot(2,1,1);
                timeDomain(real(upsampledData), 'Y', 'Resp en Tiempo');
                hold on;
                timeDomain(imag(upsampledData), 'G', 'Resp en Tiempo');
                legend('Real', 'Imaginario');
                subplot(2,1,2);
                frequencyDomain(upsampledData, 'B', 'Resp en Frecuencia');
            end
        end
        
        %% Transmisión (TX) - Filtro
        % Filtro de 59 coeficientes
        coefficientsTx = [-0.000784349139504251, -0.000176734735785689, 0.000724012692320556,...
            0.00118554682461376, 0.000561224222290113, -0.00100201539035489,...
            -0.00222659432222206, -0.00152383506917547, 0.00128589170200708,...
            0.00400894535406963, 0.00348933001770781, -0.00115361405151310,...
            -0.00650114618880027, -0.00691923964988450, 5.99346493618398e-18,...
            0.00952959027858301, 0.0123552446794401, 0.00303688616696274,...
            -0.0127969830957593, -0.0206395422737169, -0.00938114247892921,...
            0.0159261635482031, 0.0337387363038249, 0.0222822647110203,...
            -0.0185216204263869, -0.0586008851851700, -0.0540413312902093,...
            0.0202371971192971, 0.145587146371200, 0.264043788776860,...
            0.312554129058022, 0.264043788776860, 0.145587146371200,...
            0.0202371971192971, -0.0540413312902093, -0.0586008851851700,...
            -0.0185216204263869, 0.0222822647110203, 0.0337387363038249,...
            0.0159261635482031, -0.00938114247892921, -0.0206395422737169,...
            -0.0127969830957593, 0.00303688616696274, 0.0123552446794401,...
            0.00952959027858301, 5.99346493618398e-18, -0.00691923964988450,...
            -0.00650114618880027, -0.00115361405151310, 0.00348933001770781,...
            0.00400894535406963, 0.00128589170200708, -0.00152383506917547,...
            -0.00222659432222206, -0.00100201539035489, 0.000561224222290113,...
            0.00118554682461376, 0.000724012692320556, -0.000176734735785689,...
            -0.000784349139504251];     
        filterTx = conv(upsampledData, coefficientsTx, 'same');

        %% Imprimiendo resultados (7)
        if (count == 0)
            disp('Filtro')
            toPrint = input('Resultado de Filtro (S / N) - ', 's');
        end
        if (toPrint == 'S' || toPrint == 's')
            if (slot==1 && symbol==1)
                figure;
                subplot(2,2,1);
                frequencyDomain(upsampledData(1:2192), 'B', 'Dominio F del Filtro TX');
                subplot(2,2,2);
                frequencyDomain(coefficientsTx, 'B', 'Resp F del filtro TX');
                subplot(2,2,3);
                frequencyDomain(filterTx(1:2192), 'B', 'Resultado del filtro TX');
            end
        end
        
        %% Imprimiendo resultados (8)
        if (count == 0)
            disp('Señal analogica')
            toPrint = input('Resultado de Señal analogica (S / N) - ', 's');
        end
        if (toPrint == 'S' || toPrint == 's')
            if (slot==1 && symbol==1)
                figure;
                fs = 7.68*10^6;
                t = (0:5.94*10^-11:1/fs);
                t = t(1:2192);
                plot(t, abs(filterTx(1:2192)));
                title('Salida analogica del filtro TX');
                xlabel('Tiempo'); ylabel('Amplitud');
                legend('Tasa de sobremuestreo: 7.68/1.15');
            end
        end
        
        %% Canal con ruido AWGN o Rayleigh
        for x = 1:length(SNR)            
            if (channelType == 0)
                outputChannel = awgnChannel(filterTx, SNR(x));
            elseif (channelType == 1)
                [outputChannel, HH] = rayleighChannel(filterTx, SNR(x));
            end
            
            %% Receptor (RX) - Filtro
            coefficientsRx=[-0.000784349139504251, -0.000176734735785689, 0.000724012692320556,...
                0.00118554682461376, 0.000561224222290113, -0.00100201539035489,...
                -0.00222659432222206, -0.00152383506917547, 0.00128589170200708,...
                0.00400894535406963, 0.00348933001770781, -0.00115361405151310,...
                -0.00650114618880027, -0.00691923964988450, 5.99346493618398e-18,...
                0.00952959027858301, 0.0123552446794401, 0.00303688616696274,...
                -0.0127969830957593, -0.0206395422737169, -0.00938114247892921,...
                0.0159261635482031, 0.0337387363038249, 0.0222822647110203,...
                -0.0185216204263869, -0.0586008851851700, -0.0540413312902093,...
                0.0202371971192971, 0.145587146371200, 0.264043788776860,...
                0.312554129058022, 0.264043788776860, 0.145587146371200,...
                0.0202371971192971, -0.0540413312902093, -0.0586008851851700,...
                -0.0185216204263869, 0.0222822647110203, 0.0337387363038249,...
                0.0159261635482031, -0.00938114247892921, -0.0206395422737169,...
                -0.0127969830957593, 0.00303688616696274, 0.0123552446794401,...
                0.00952959027858301, 5.99346493618398e-18, -0.00691923964988450,...
                -0.00650114618880027, -0.00115361405151310, 0.00348933001770781,...
                0.00400894535406963, 0.00128589170200708, -0.00152383506917547,...
                -0.00222659432222206, -0.00100201539035489, 0.000561224222290113,...
                0.00118554682461376, 0.000724012692320556, -0.000176734735785689,...
                -0.000784349139504251];
            filterRx = conv(outputChannel, coefficientsRx, 'same').';
            
            if (channelType == 1) % Rayleigh
                % Ecualización
                G_ZF = 1 ./ HH; 
                rxFFT = fft(filterRx);
                equalizationFFT = G_ZF' .* rxFFT;
                equalization = fft(equalizationFFT); 

                %% Imprimiendo resultados (9)
                if (count == 0)
                    disp('Señal con filtro RX')
                    toPrint = input('Resultado de Señal analogica (S / N) - ', 's');
                end
                if (toPrint == 'S' || toPrint == 's')
                    if  SNR(x) == 5 && symbol==1 && slot==1
                        figure;
                        subplot(2,1,1);
                        frequencyDomain(outputChannel, 'B', 'Freq response before Rx. filter');
                        subplot(2,1,2);
                        frequencyDomain(filterRx, 'R', 'Freq response after Rx.filter');
                    end
                end
            end
            
            %% DesMuestreador
            if(channelType == 0)
                downsampledData = downsampling(filterRx);
            else
                downsampledData = downsampling(equalization);
            end
            
            %% Quitando CP
            dataNoCP = removeCP(downsampledData);
            
            %% FFT
            fftData = fft(dataNoCP, 512);
            fftData = ifftshift(fftData);
            
            %% Demapeo de Subcarrier
            subcarrierInd = [-150:-1 1:150];
            demappedData = zeros(300, 1);
            for y = 1:300
                demappedData(y) = fftData(subcarrierInd(y) + 512 / 2 + 1);
            end
            
            %% Demultiplexaje
            [demultiplexedData, demultiplexedPilot] = demultiplexing(demappedData, symbol);
            
            %% Demodulación de símbolos
            demodulatedData = demodulatorQAM(demultiplexedData);
            rxData(x, (r + 1):(r + length(demodulatedData))) = demodulatedData;
            
            %% Demodulated signal(200 samples) in timeDomain and frequency domain 
            if(count==0)
                disp('Checkpoint 3.b-Demodulated signal(200 samples) in timeDomain and frequency domain for SNR=-10dB ');
                pause
            end
            if SNR(x) == 5 && symbol==1 && slot==1 
                figure;
                subplot(2,1,1);
                timeDomain(rxData(200:400), 'B', 'Time domain of demodulated signal');
                subplot(2,1,2);
                frequencyDomain(rxData(200:400), 'R', 'Frequency domain of demodulated signal');
            end                  


            %% Checkpoint 3.c-- Comparing for SNR_dB=-10 and SNR_dB=10 and SNR_dB=0 
            if(count==0)
            disp('Checkpoint 3.c-- Comparing for SNR_dB=-10 and SNR_dB=10 and SNR_dB=0');  
            pause
            end
            if SNR(x) == -10  && symbol == 1 && slot == 1
                SNRDb=-10;                
                figure;
                subplot(3,1,1);
                timeDomain(data(200:400), 'B', 'Time Response of Tx Data Bits at SNR -10 db');
                subplot(3,1,2);
                timeDomain(rxData(200:400), 'R', 'Time Response of Rx Data Bits at SNR -10 db');
                subplot(3,1,3);
                timeDomain(data(200:400) - rxData(200:400), 'G', 'Comparing the Tx and Rx bits at-10db');
            end    

            if SNR(x) == 0  && symbol == 1 && slot == 1
                SNRDb=0;
                figure;
                subplot(3,1,1);
                timeDomain(data(200:400), 'B', 'Time Response of Tx Data Bits at SNR 0 db');
                subplot(3,1,2);
                timeDomain(rxData(200:400), 'R', 'Time Response of Rx Data Bits at SNR 0 db');
                subplot(3,1,3);
                timeDomain(data(200:400) - rxData(200:400), 'G', 'Comparing the Tx and Rx bits at 0');
            end    

            if SNR(x) == 10  && symbol == 1 && slot == 1
                SNRDb=10;  
                figure;
                subplot(3,1,1);
                timeDomain(data(200:400), 'B', 'Time Response of Tx Data Bits at SNR 10 db');
                subplot(3,1,2);
                timeDomain(rxData(200:400), 'R', 'Time Response of Rx Data Bits at SNR 10 db');
                subplot(3,1,3);
                timeDomain(data(200:400) - rxData(200:400), 'G', 'Comparing the Tx and Rx bits at 10db');                   
            end
            
            count = count + 1;
        end
        r = r + length(demodulatedData);
    end    
end

%% Decodificacion LDPC
% rxDataDecod = decodification(rxData(12,:), length(rxData(12,:)));

%% Imagen recibida
if(choice == 2)
    writeImage(rxData(12,:));  
end

%% BER
k = 4;
for x = 1:length(SNR)
   ber(x) = length(find(xor(data(1:8000), rxData(x,1:8000)))) / 8000;
end
theoryBer = (1/k) * 3/2 * erfc(sqrt(k * 0.1 * (10.^(SNR / 10))));

figure;
semilogy(SNR, ber, 'B');
hold on
semilogy(SNR, theoryBer, 'R');
title('Curva de BER');
xlabel('SNR'); ylabel('BER');
axis([-10 20 10^-2.6 1]);
legend('Simulacion', 'Teoria');
hold off;
