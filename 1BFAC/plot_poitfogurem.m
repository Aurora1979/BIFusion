clc;
clear all;
close all;
%计算Imean和adaptuve_gamma的值

for i=1:21

index =i;
path2 = ['D:\matlabworkplace\superpixel_test\newtest2\iv\VIS',num2str(index),'.png'];
VI=imread(path2);
image=gray2rgb(VI);
HSV = rgb2hsv( double(image) );   % RGB space to HSV  space
S = HSV(:,:,3);       % V layer
Imean=mean(S(:))/255;
X(i,1)=Imean
gamma=log(((1-Imean)/Imean)+2);
G(i,1)=gamma;




end