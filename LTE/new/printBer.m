function printBer(EbNoVec, M, berVec)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    berTheory = berawgn(EbNoVec, 'psk', M, 'nondiff');
    figure
    semilogy(EbNoVec, berVec(:, 1), '*');
    hold on
    semilogy(EbNoVec, berTheory);
    legend('Simulaci�n', 'Teoria', 'Location', 'Best')
    xlabel('Eb/No (dB)')
    ylabel('BER')
    grid on
    hold off
end

