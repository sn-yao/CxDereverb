close all
h0 = figure('position',[100 200 300 500]','Name','Cx Dereverb');
uicontrol('parent',h0,'style','text','fontsize',12,'string',filename,'position',[55 380 200 30]);
pb1=  uicontrol('parent',h0,'style','pushbutton','fontsize',12,'string','Choose an audio file','position',[20 420 260 50]);
pb2 = uicontrol('parent',h0,'style','pushbutton','fontsize',12,'string','Next','position',[50 15 200 30]);
set(pb1,'callback','select');
set(pb2,'callback','produceInv');

uicontrol('parent',h0,'style','text','fontsize',12,'string','sampling freq.:','position',[5 330 120 30]);
fsX=uicontrol('parent',h0,'style','slider','position',[10 300 280 24],'min',0,'max',3900);
%
ht = uicontrol('style','edit','Position',[125,330,60,30]);
fs_txt = @(~,e)set(ht,'String',num2str(round(get(e.AffectedObject,'Value'))+44100),'fontsize',12);
addlistener(fsX, 'Value', 'PostSet',fs_txt);

uicontrol('parent',h0,'style','text','fontsize',12,'string','low freq.:','position',[5 250 120 30]);
spLx=uicontrol('parent',h0,'style','slider','position',[10 220 280 24],'min',0,'max',200);
%
ht1 = uicontrol('style','edit','Position',[125,250,60,30]);
LF_txt = @(~,e)set(ht1,'String',num2str(round(get(e.AffectedObject,'Value'))),'fontsize',12);
addlistener(spLx, 'Value', 'PostSet',LF_txt);

uicontrol('parent',h0,'style','text','fontsize',12,'string','high freq.:','position',[5 170 120 30]);
spHx=uicontrol('parent',h0,'style','slider','position',[10 140 280 24],'min',0,'max',4000);
%
ht2 = uicontrol('style','edit','Position',[125,170,60,30]);
HF_txt = @(~,e)set(ht2,'String',num2str(round(get(e.AffectedObject,'Value'))+16000),'fontsize',12);
addlistener(spHx, 'Value', 'PostSet',HF_txt);

uicontrol('parent',h0,'style','text','fontsize',12,'string','ridge parameter:','position',[5 90 120 30]);
betaX=uicontrol('parent',h0,'style','slider','position',[10 60 280 24],'min',0,'max',0.1);
%
ht3 = uicontrol('style','edit','Position',[125,90,60,30]);
beta_txt = @(~,e)set(ht3,'String',num2str(get(e.AffectedObject,'Value')),'fontsize',12);
addlistener(betaX, 'Value', 'PostSet',beta_txt);
%axes('Position',[.35 .3 .3 .3]);              
%imshow('NTUA.png')