function [q1, q2, q3, q4] = getAllQuantiz(fn, t, tMin, tMax, name)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    figure();
    subplot(5, 1, 1); plot(t(tMin:tMax), fn(tMin:tMax));
    title(strcat('Señal original: ', name))
    i = 2;
    for x=[1.0, 0.5, 0.2, 0.1]
        index = quantiz(fn(tMin:tMax), -3:x:3);
        index = index / max(index) * 6 - 3; 
        subplot(5, 1, i); plot(t(tMin:tMax), index);
        str = sprintf('Quantizador con %f', x);
        title(str)
        if i == 2
            q1 = index;
        end
        if i == 3
            q2 = index;
        end
        if i == 4
            q3 = index;
        end
        if i == 5
            q4 = index;
        end
        i = i + 1;
    end
end

