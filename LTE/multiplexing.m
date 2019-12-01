function output = multiplexing(data, pilot, symbol)
%MULTIPLEXING Crenado multiplexaje entre los datos y la señal piloto
%modulados por símbolo
    pilotCounter = 1;
    dataCounter = 1;
    loop = length(data) + length(pilot);
    if (numel(pilot) == 0)
        output = data;
    elseif (symbol == 1) % Primer símbolo de cada slot
        for i = 1:1:loop
            if (mod(i, 6) == 0)
                output(i) = pilot(pilotCounter);
                pilotCounter = pilotCounter+1;
            else 
                output(i) = data(dataCounter);
                dataCounter = dataCounter+1;
            end
        end
    else % Quinto símbolo de cada slot
        for i = 1:1:loop
            if (mod(i - 3, 6) == 0)
                output(i) = pilot(pilotCounter);
                pilotCounter = pilotCounter + 1;
            else
                output(i) = data(dataCounter);
                dataCounter = dataCounter + 1;
            end
        end
    end
end
