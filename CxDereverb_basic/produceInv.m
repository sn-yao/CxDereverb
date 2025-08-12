% Produce room model and inverse filter
% Users should initially excute welcomePage.m
if get(fsX,'value')==0
    fs=44100;
else
    fs=round(get(fsX,'value'))+44100;
end
if get(spLx,'value')==0
    freq_low=80;
else
    freq_low=round(get(spLx,'value'));
end
if get(spHx,'value')==0
    freq_high=20000;
else
    freq_high=round(get(spHx,'value'))+16000;
end
if get(betaX,'value')==0
    regularization_strength=0.1;
else
    regularization_strength=get(betaX,'value');
end
% Produce room impulse response
findIR;
% Determine the length of inverse filter
T60ms=estimateT60(ir,fs);
lowerExp = floor(log2(T60ms/1000*fs));
filterL = 2^lowerExp;
if filterL>32768*2
    filterL=32768*2;
end
% Produce inverse filter
findInverseFilter;
% Measure Direct-to-Reverberant Ratio (DRR)
drr_value = drr(corrected_output);
disp("DRR=")
disp(drr_value);
% Plot magnitude spectrum
[SD, SDX] = calSD(corrected_output, fs);
disp("SD=")
disp(SDX);

drr_value_before = drr(raw_IRs);
disp("DRR(before)=")
disp(drr_value_before);

[SD_before, SDX_before] = calSD(raw_IRs, fs);
disp("SD(before)=")
disp(SDX_before);

close all
h1 = figure('position',[100 200 300 500]','Name','Welcom');

pb20 = uicontrol('parent',h1,'style','pushbutton','fontsize',12,'string','Return','position',[10 460 100 30]);
set(pb20,'callback','main');

uicontrol('parent',h1,'style','text','fontsize',12,'string','Before','position',[5 420 50 30]);
uicontrol('parent',h1,'style','text','fontsize',11,'string',strcat('DRR: ',num2str(drr_value_before)),'position',[60 420 120 30]);
uicontrol('parent',h1,'style','text','fontsize',11,'string',strcat('SD: ',num2str(SDX_before)),'position',[180 420 120 30]);
axes('Position',[0.1 0.53 0.8 0.3]);
timeIdx2=(1:length(normalized_IRs))/fs;
plot(timeIdx2,normalized_IRs/max(abs(normalized_IRs)));
xlim([-0.1 0.6])

uicontrol('parent',h1,'style','text','fontsize',12,'string','After','position',[5 180 40 30]);
uicontrol('parent',h1,'style','text','fontsize',11,'string',strcat('DRR: ',num2str(drr_value)),'position',[60 180 120 30]);
uicontrol('parent',h1,'style','text','fontsize',11,'string',strcat('SD: ',num2str(SDX)),'position',[180 180 120 30]);
axes('Position',[0.1 0.05 0.8 0.3]); 
timeIdx1=(1:length(corrected_output))/fs;
corrected_outputN=corrected_output/max(abs(corrected_output));  
plot(timeIdx1(1:length(normalized_IRs)),corrected_outputN(1:length(normalized_IRs)));
xlim([-0.1 0.6])


