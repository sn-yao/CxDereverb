clear
h00 = figure('position',[100 200 300 500],'Name','Cx Dereverb');
uicontrol('parent',h00,'style','text','fontsize',12,'string','No file','position',[55 380 200 30]);
pb1=  uicontrol('parent',h00,'style','pushbutton','fontsize',12,'string','Choose an audio file','position',[20 420 260 50]);

set(pb1,'callback','select');

axes('Position',[.1 .05 .8 .5]);              
imshow('UserM.png')

uicontrol('parent',h00,'style','text','fontsize',11,'string','The left channel of audio file is s[n].','position',[10 280 280 20]);
uicontrol('parent',h00,'style','text','fontsize',11,'string','The right channel of audio file is m[n].','position',[10 260 280 20]);