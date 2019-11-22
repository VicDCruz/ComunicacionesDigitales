close all; clear; clc;
s = 8; duration = 5;
from = 0; to = 400;
t = linspace(0, 2, to / s);
pul = getPulse(from, to, duration, s);
figure(); stem(pul);
fs = 1 / (0.1 / 1000);
% for fc = [300, 700, 1200]
%     figure();
%     [b, a] = butter(6, fc / (fs / 2));
%     % freqz(b, a);
%     % figure();
%     dataOut = filter(b, a, pul);
%     plot(dataOut)
% end
fil = raisedCosine();
coeff = fil.coeffs();
dataOut = filter(coeff.Numerator, [1], pul);
figure(); plot(dataOut);