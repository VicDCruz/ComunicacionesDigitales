function channel = awgnChannel(input, snr)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
    fs = 7.68*10^6;
    bw = 5*10^6;
    samplesTotal = 2192;
    power = var(abs(input)); % determing the power of the symbol to be transmitted
    energy = power * samplesTotal;
    snrLinear = 10^(snr / 10); % conversion signal to noise level into linear from decibels
    factor = sqrt((energy * fs * 4) / (snrLinear * bw * 512)); % determining the noise factor
    % generating zero mean complex noise
    noise = (randn(1, length(input)) + 1i * randn(1, length(input))) * 0.5 * factor ;
    channel = input + noise; % adding the noise to the symbol to be transmitted
end

