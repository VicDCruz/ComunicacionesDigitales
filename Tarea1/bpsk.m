clear all
clc
r=round(rand(1,10000));
for i=1:10000
    if r(i)==0
        s(i)=-1;
    else
        s(i)=1;
    end
end
k=1;
for snrdb=1:1:15
    v=1/(10^(snrdb/10));
x=awgn(s,snrdb,'measured');
%n1=sqrt(v/2)*randn(1,10000);
%n2=sqrt(1/2)*randn(1,10000);
%n=sqrt(n1.*n1+n2.*n2);
y=x;
for j=1:10000
    if y(j)>0
        z(j)=1;
    else
        z(j)=0;
    end
end
error=length(find(z~=r));
ber(k)=error/10000;
k=k+1;
end
snrdb=1:1:15;
snrlin=10.^(snrdb./10);
tber=0.5.*erfc(sqrt(snrlin));
semilogy(snrdb,ber,'-bo', snrdb,tber,'-mh')
grid on
title('BPSK with AWGN');
xlabel('Signal to noise ratio');
ylabel('Bit error rate');
