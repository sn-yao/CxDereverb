%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% <INPUTs>
% x        : room model.
% fs       : sampling rate.
% <OUTPUTs>
% sd       : spectrum distortion from 0 Hz to fs/2 Hz.
% sdx      : spectrum distortion from 100 Hz to 16000 Hz.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% <EXAMPLE>
% x = load('small.mat');
% fs = 44100;
% plot(linspace(0,50,1e4), MUSIC);
% disp(sdx);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sd,sdx] = calSD(x,fs)
x=x./max(abs(x));
if (nargin < 2)
	fs = 44100;
end
fx = fft(x,fs);
freq = (0 : fs/2);
sd = std(20*log10(abs(fx(1:(fs/2 + 1)))));
sdx=std(20*log10(abs(fx(100:16000))));


