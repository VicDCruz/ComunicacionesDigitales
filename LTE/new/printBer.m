function printBer(EbNoVec, M, berVec, name, decision)
%PRINTBER Obtener la gráfica de BER (teórico e experimental)
    if (decision == 0)
        berTheory = berawgn(EbNoVec, 'psk', M, 'nondiff');
    else
        berTheory = berturbocode(EbNoVec);
    end
    figure
    semilogy(EbNoVec, berVec(:, 1), '*');
    hold on
    semilogy(EbNoVec, berTheory);
    legend('Simulación', 'Teoria', 'Location', 'Best')
    xlabel('Eb/No (dB)')
    ylabel('BER')
    title(name);
    grid on
    hold off
end

