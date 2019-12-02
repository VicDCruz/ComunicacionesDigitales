function output = rayleigh(data, snr)
%RAYLEIGH Generar distorsiones en un canal con ruido
% de Rayleigh
    N0 = 1/10^(snr/10); % Varianza del ruido
    h = 1/sqrt(2) * (randn(length(data), 1) + 1i * randn(length(data), 1)); 
    output = h .* data + sqrt(N0/2) * (randn(length(data), 1)+ 1i * randn(length(data), 1));
end

