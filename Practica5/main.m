close all; clear; clc;
s = 0.1; duration = 5;
from = 0; to = 100;
t = linspace(0, 1, to / s);
pul = getPulse(from, to, duration, s);
figure(); plot(t, pul); axis([0 1 -1.5 1.5]);
fs = 1 / (0.1 / 1000);
for fc = [300, 700, 1200]
    figure();
    [b, a] = butter(6, fc / (fs / 2));
    % freqz(b, a);
    % figure();
    dataOut = filter(b, a, pul);
    plot(dataOut)
end
