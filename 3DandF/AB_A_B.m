%% image fusion using ML1L0 VSM WLS 
close all
clear ;


for i=1:1
index =13;
path1 = ['D:\matlabworkplace\superpixel_test\newtest2\iv\IR',num2str(index),'.png'];
%path2 = ['adaptive_VIS/denoiseVIS',num2str(index),'.png'];
path2 = ['iv/VIS',num2str(index),'.png'];
%path2 = ['D:\360MoveData\Users\LKOII\Desktop\3_ALL\result1\LN\原文献统一2.2结果\VIS_',num2str(index),'.png'];
%path2 = ['D:\360MoveData\Users\LKOII\Desktop\3_ALL\result2\ln+2\VIS',num2str(index),'.png'];
path3=['D:\360MoveData\Users\LKOII\Desktop\3_ALL\result2\meanvalue_decisionmap\IR_',num2str(index),'.png'];
%% input images
im1 = im2double(imread(path1));
im2 = im2double(imread(path2));
im3=im2double(imread(path3));


     % Convert to single channel
if size(im1, 3)~=1
im1 = rgb2gray(im1);
end
if size(im2, 3)~=1
im2 = rgb2gray(im2);
end
%figure,imshow(im1);
%% Fusion
tic
F=fusion_ab_GIPT(im1,im2,im3,index);
%F = fusion1(im1,im2,im3);
%F=lp_fuse_ir1(im1,im2,im3);
toc

%%
dir1='D:\360MoveData\Users\LKOII\Desktop\3_ALL\result2\without_A_B\';
path3 = [dir1,'F_',num2str(index),'.png'];
%figure,imshow(F,[]);
imagesc(F);
axis off;
%figure,imshow(F),title('F');
%imwrite(F,path3);
%dir1='D:\360MoveData\Users\LKOII\Desktop\test_double\fuse9\';%you path to store the prefusion image
%path3 = [dir1,'Fuse9_',num2str(index),'.png'];
%imwrite(F,path3);
%figure,imshow(F),title('F');
%figure,imshow(F,[]),title('F1');
%figure,imshow(weightmap);
%% 
end