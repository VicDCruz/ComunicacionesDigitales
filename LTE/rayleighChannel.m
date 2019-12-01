function [output, H] = rayleighChannel(input, snr)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
    lengthInput = length(input);
    % Number of taps within the channel impulse response
    channelsTotal = 10;           
    % Factor for exponentially decaying power profile:
    attenuationFactor = 8;          
    % Calculate variances of channel taps according to exponetial decaying power profile
    channelVariance = exp(-(0:channelsTotal - 1) / attenuationFactor);  
    channelVariance = channelVariance / sum(channelVariance); % Normalize overall average channel power to one

    % Generate random channel coefficients (Rayleigh fading)
    coefficients = sqrt(0.5) * (randn(1, channelsTotal) + 1i * randn(1, channelsTotal)) .* sqrt(channelVariance); 
    % Calculate corresponding frequency response (needed for receiver part)
    freqResp = [coefficients zeros(1, lengthInput - channelsTotal)]; % Zero-padded channel impulse response (length Nc)
    H = fft(freqResp); % Corresponding FFT 

    % Received sequence --> Convolution with channel impulse response
    y = conv(input, freqResp, 'same');

    % Add AWGN 
    fs = 7.68*10^6;
    BW = 5*10^6;
    samplesTotal = 2192;
    power = var(abs(input)); % determing the power of the symbol to be transmitted
    energy = power * samplesTotal;
    snrLinear = 10^(snr/10); % convertion signal to noise level into linear from decibels

    bitsPerSymbol = 4; % 16QAM - log2(16)

    noiseFactor =sqrt((energy*fs*bitsPerSymbol)/(snrLinear*BW*512)); % determining the noise factor
    % generating normalized noise in complex form with mean 0 and variance 1

    n =(randn(1,length(input))+1i*randn(1,length(input)))*.5*noiseFactor ;
    y = y + n;

    % Discard last Nch-1 received values resulting from convolution 
    output=y;
end
