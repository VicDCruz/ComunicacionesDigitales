function getAllSnr(fn, q1, q2, q3, q4, tmin, tmax)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
fprintf('SNR con 1: %f\n', 10*log(rms(fn(tmin:tmax)) ./ rms(fn(tmin:tmax)-q1)).^2);
fprintf('SNR con 0.5: %f\n', 10*log(rms(fn(tmin:tmax)) ./ rms(fn(tmin:tmax)-q2)).^2);
fprintf('SNR con 0.2: %f\n', 10*log(rms(fn(tmin:tmax)) ./ rms(fn(tmin:tmax)-q3)).^2);
fprintf('SNR con 0.1: %f\n', 10*log(rms(fn(tmin:tmax)) ./ rms(fn(tmin:tmax)-q4)).^2);
end

