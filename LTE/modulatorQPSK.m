function output = modulatorQPSK(pilot)
%MODULATORQPSK Modulación QPSK de cada 2 bits del piloto a 1 simbolo
    lengthPilot = length(pilot); % length of the data stream
    ip = zeros(1, floor(lengthPilot / 2));  % Intializing a matrix with zeros
    % Gray coded Mapping
    % 00 -1-j   01 -1+j   10 1-j     11-1+j
    for i = 1:(lengthPilot - 1)
        ip(i) = 1 / (sqrt(2) * 1i * (1 - 2 * pilot(i))) + 1 / (sqrt(2) * (1 - 2 * pilot(i + 1)));
    end
    output = ip(1:1:length(ip)); % Taking the odd elements to form the symbol matrix
end

