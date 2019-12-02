# Implementación LTE

## Descripción
Proyecto final de la materia Comunicaciones Digitales, correspondiente al semestre Ago-Dic 2019.
Simulación sobre la capa física de LTE por medio de Matlab y sus componentes en comunicaciones. Basado en las especificaciones de 3GPP.
Favor de correr `Main.m` para correr la simulación

## Integrantes
- Víctor Cruz - ITAM
- Brandon Hernández - ITAM
- Octavio Ordaz - ITAM

## Componentes
1. Datos: Aleatorios o Imagen
2. Codificación por Turbo códigos
3. Modulación QPSK
4. Modulación OFDM
5. Canal AWGN | Rayleigh
6. Demodulación OFDM
7. Demodulación QPSK
8. Decodificación por Turbo códigos

## Archivos

### Funciones
- Codificación
- Decodificación
- Modulación QPSK
- Modulación OFDMA
- Demodulación QPSK
- Demodulación OFDM
- Obtener las subcarriers de OFDM
- Imprimir una gráfica de BER
- Leer una imagen desde un archivo
- Imprimir una imagen por una matriz de bits
- Creación de un canal con ruido de Rayleigh

### Otros
Este proyecto cuenta con una carpeta de imágenes para analizar diferentes casos y su comportamiento ante el canal.
Para agregar o modificar una imagen, dirigirse hacia `../img/`


## Funcionamiento
- Para correr el sistema, ver `Main.m`, después elegir las opciones
    1. Elegir el tipo de ruido (AWGN o Rayleigh)
    2. Elegir el tipo de información (Bits random o Imagen precargada)
       1. Nombre del archivo dentro de la carpeta `../img`
- Para cambiar SNR, verificar `snrVec`

## Referencias
- https://la.mathworks.com/help/comm/ug/estimate-turbo-code-ber-performance-in-awgn.html
- https://la.mathworks.com/help/comm/gs/qpsk-and-ofdm-with-matlab-system-objects-1.html
- https://la.mathworks.com/help/comm/ref/comm.ldpcencoder-system-object.html#bsyh0xo-5