% Select audio file from computer 
% Users should initially excute welcomePage.m
 [file,path] = uigetfile('*.wav');
if isequal(file,0)
   filename='NaN.wav';
else
   filenameall=([fullfile(path,file)]);
   filename=([fullfile(file)]);
end

close all


main

