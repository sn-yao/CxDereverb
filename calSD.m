function [sd,sdx] = calSD(x,fs)
x=x./max(abs(x));
if (nargin < 2)
	fs = 44100;
end
fx = fft(x,fs);
freq = (0 : fs/2);
sd = std(20*log10(abs(fx(1:(fs/2 + 1)))));
sdx=std(20*log10(abs(fx(100:16000))));

