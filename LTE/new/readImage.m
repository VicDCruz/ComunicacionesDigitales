function output = readImage(path)
    %READIMAGE Convertir imagen a bits
    cd(pwd);
    cd('../img');
    data = imread(path);
    data = imbinarize(data); % to B&W
    data = data(:,:,1);
    disp('Imagen a transmitir...');
    figure();
    imshow(data)
    disp('Ajustando la imagen a un cuadrado');
    resized = imresize(data, [400 400]);
    resized = im2double(resized);
    resized = fix(resized);
    cd('../new');
    output = reshape(resized', 1, 160000);
end

