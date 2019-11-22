% BPSK
bpsk = comm.BPSKModulator;
constellation(bpsk)
title('BPSK')

% QPSK
qpsk = comm.QPSKModulator;
constellation(qpsk)
title('QPSK')

% 16-QAM
M = 16;
d = randi([0 M-1],1000,1);
y1 = qammod(d,M,'bin','PlotConstellation',true);
title('16-QAM')

% 16-QAM
M = 64;
d = randi([0 M-1],1000,1);
y2 = qammod(d,M,'bin','PlotConstellation',true);
title('64-QAM')

