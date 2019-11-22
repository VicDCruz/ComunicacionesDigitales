clear all; clc; close all;
%% 1) Generar señales
% a) Ruido
noise = wgn(1, 100000, 0);
% b) Senoidal
Fs = 2000; % F muestreo
t = 0:1/Fs:500 - 1/Fs; % 1 segundo
f = 10; % freq de onda
sen = sin(2*pi*t*f) * 3;
% c) Rampa
rampa = sawtooth(2 * pi * t * f) * 3;
% rampa = 0:1/F:1 - 1/Fs;
% rampa = (rampa * 6) - 3;

%% 2) Quantiz
for x=1:1
min = 1; max = 1 * Fs;
fprintf('---Señal ruido---\n');
[q1, q2, q3, q4] = getAllQuantiz(noise, t, min, max, 'ruido');
getAllSnr(noise, q1, q2, q3, q4, min, max);
fprintf('---Señal senoidal---\n');
[q1, q2, q3, q4] = getAllQuantiz(sen, t, min, max, 'senoidal');
getAllSnr(sen, q1, q2, q3, q4, min, max);
fprintf('---Señal rampa---\n');
[q1, q2, q3, q4] = getAllQuantiz(rampa, t, min, max, 'rampa');
getAllSnr(rampa, q1, q2, q3, q4, min, max);
end