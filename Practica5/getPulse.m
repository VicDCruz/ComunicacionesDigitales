function output = getPulse(from, to, duration, sample)
    len = abs(from - to) / sample;
    output = zeros(1, len);
    rectangle = duration / sample;
    actual = 1;
    new = rectangle;
    for x = 1:abs(from - to) / duration
        r = rand();
        value = -1;
        if r > 1 / 2
            value = 1;
        end
        if rectangle > 1
            output(actual:new) = value * ones(1, rectangle);
            actual = new + 1;
            new = new + rectangle;
        else
            output(actual + round(duration / 2)) = value;
            actual = actual + duration;
        end
    end
end

