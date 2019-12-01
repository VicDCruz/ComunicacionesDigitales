function frequencyDomain(data, color, name)
%FREQUENCYDOMAIN Mostrar datos en el dominio de la frecuencia
    N = 512;
    deltaF = 15 * 10^3; % Espaciado de los subcarriers
    fs = N * deltaF; % Frecuencia de muestreo
    ts = 1 / fs; % Periodo de muestreo
    dataSampled = fft(data) * ts;
    dataSs = fftshift(dataSampled);
    len = length(dataSampled) - 1;
    ff = fs/len;
    f = (0:ff:fs) - fs/2;
    % stem(real(Hcentered),imag(Hcentered))
    plot(f, abs(dataSs), color)
    title(name);
    xlabel('Frecuencia');
    ylabel('Respuesta en Frecuencia');
end

