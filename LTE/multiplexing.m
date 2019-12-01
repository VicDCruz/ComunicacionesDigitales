function output = multiplexing(data, pilot, symbol)
%MULTIPLEXING Crenado multiplexaje entre los datos y la se�al piloto
%modulados por s�mbolo
    pilotCounter = 1;
    dataCounter = 1;
    loop = length(data) + length(pilot);
    if (numel(pilot) == 0)
        output = data;
    elseif (symbol == 1) % Primer s�mbolo de cada slot
        for i = 1:1:loop
            if (mod(i, 6) == 0)
                output(i) = pilot(pilotCounter);
                pilotCounter = pilotCounter+1;
            else 
                output(i) = data(dataCounter);
                dataCounter = dataCounter+1;
            end
        end
    else % Quinto s�mbolo de cada slot
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
