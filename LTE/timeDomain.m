function timeDomain(data, color, name)
%TIMEDOMAIN Mostrar datos en el dominio del tiempo
    stem(data, color);
    title(name);
    xlabel('Indice'); ylabel('Amplitud');
    minData = floor(real(min(data)));
    maxData = ceil(real(max(data)));
    if (minData == maxData)
        minData = minData - 2;
        maxData = maxData + 2;
    end
    axis([0 ceil(length(data) * 1.15) (minData * 1.15) (maxData * 1.15)]);
end

