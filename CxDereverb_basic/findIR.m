
ess_mic=audioread(filenameall);
idx_i=1;
first_peak=0;
portion_onset=0.2413;
peak=max(ess_mic(:,1));
while first_peak<portion_onset*peak 
    if ess_mic(idx_i,1)>portion_onset*peak
        first_peak=ess_mic(idx_i,1);
    end
    idx_i=idx_i+1;
end
start_point=idx_i-798;
if (start_point+fs*60-1)>length(ess_mic)
    ess_mic=[ess_mic;zeros((start_point+fs*60)-length(ess_mic),2)];
end
sp=ess_mic(start_point:start_point+fs*60-1,1);
mi=ess_mic(start_point:start_point+fs*60-1,2);
sp=sp./max(abs(sp));
mi=mi./max(abs(mi));
sp3 = zeros(4,fs*15);
mi3 = zeros(4,fs*15);
for i=1:4
    sp3(i,:) = sp(1+(fs*15)*(i-1):fs*15*i,1);
    mi3(i,:) = mi(1+(fs*15)*(i-1):fs*15*i,1);
end
ir4 = zeros(4,fs*6);
irf4fft = zeros(4,fs*6);
for i=1:4
    ir4(i,:) = estimateIR_SweptSine(sp3(i,:)', mi3(i,:)', fs*6);
    ir4fft(i,:) = fft(ir4(i,:)); 
end
ir = ifft(mean(ir4fft(1:3,1:fs*6)));
ir=ir';
