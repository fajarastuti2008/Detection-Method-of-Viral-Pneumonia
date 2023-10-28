function [I2,Y2]=readDicomSlice(dicomFolderPath)
info = dicominfo(dicomFolderPath);
Y = dicomread(info);
Y2=mat2gray(Y);
ri=info.RescaleIntercept;
% ri=-1024;
rs=info.RescaleSlope;
I=int16(Y);
if min(min(I))==0
   I2=rs*I+(-1024);
else
   I2=rs*I+ri;
end
