%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paremeter Explanation
% If the detection effect is not good, you can adjust these parameters:
% Input: opts.sigma  = sigma;
 %opts.theta  = 0.00001-0.0001;   % controls \alpha     weight of fibered-rank
 %opts.varpi  = 0.03-0.6;   % controls \lambda_2  \|T\|_1
 %opts.omega  = 10000;   % controls \tau       SVT
% opts.logtol = 0.000001;      % \varepsilon in LogTFNN
% Output: None
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If you have any questions, please contact:
% Author: Xuan Kong
% Email: 13558713606@163.com
% Copyright:  University of Electronic Science and Technology of China
% Date: 2021/3/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%* License: Our code is only available for non-commercial research use.
clear;
clc;
close all;

%addpath('E:\鐮斾簩涓奬寮犻噺/LogTFNN/lib/')
%addpath('E:\鐮斾簩涓奬寮犻噺/LogTFNN/lib/ToolBox/')
%addpath('E:\鐮斾簩涓奬寮犻噺/LogTFNN/lib/ToolBox/tensor_toolbox/')
%imgpath = 'E:\鐮斾簩涓奬寮犻噺/LogTFNN/images/';


for i=1:1
    index=8;
addpath('D:\matlabworkplace\P3\IGPT\lib\')
addpath('D:\matlabworkplace\P3\IGPT\lib\ToolBox\')
addpath('D:\matlabworkplace\P3\IGPT\lib\ToolBox\tensor_toolbox\')
imgpath = ['D:\matlabworkplace\P3\IGPT\IR\IR',num2str(index),'.png'];
%imgpath1 = ['D:\360MoveData\Users\LKOII\Desktop\enhancedir\IR',num2str(index),'.png'];

img=imread(imgpath);
%figure,imshow(img);
% patch parameters
patchSize = 40;
slideStep = 40;

%img = imread([imgpath imgDir.name]);
%figure,subplot(221)
%imshow(img),title('Original image')

if ndims( img ) == 3
   img = rgb2gray( img );
end
img = double(img);
[hei, wid] = size(img);
%% constrcut patch tensor of original image
tenD = gen_patch_ten(img, patchSize, slideStep);
[n1,n2,n3] = size(tenD);  
  
%% calculate prior weight map
%      step 1: calculate two eigenvalues from structure tensor
[lambda1, lambda2] = structure_tensor_lambda(img, 3);
%      step 2: calculate corner strength function
cornerStrength = (((lambda1.*lambda2)./(lambda1 + lambda2)));
%      step 3: obtain final weight map
maxValue = (max(lambda1,lambda2));
priorWeight = mat2gray(cornerStrength .* maxValue);
%subplot(222),imshow(priorWeight,[]),title('priorWeight image')
%      step 4: constrcut patch tensor of weight map
tenW = gen_patch_ten(priorWeight, patchSize, slideStep);
    
%% The proposed model
Nway = size(tenD);
sigma=1;

opts=[];
opts.sigma  = sigma;
opts.theta  = 0.00001;   % controls \alpha     weight of fibered-rank
opts.varpi  = 0.04;   % controls \lambda_2  \|T\|_1
opts.omega  = 10000;   % controls \tau       SVT
opts.logtol = 0.000001;      % \varepsilon in LogTFNN

[tenB,tenT,~,~]=my_LogTFNN(tenD,tenW,opts);
tarImg = res_patch_ten_mean(tenT, img, patchSize, slideStep);
backImg = res_patch_ten_mean(tenB, img, patchSize, slideStep);


%% preresult
maxv = max(max(double(img)));
E = uint8( mat2gray(tarImg)*maxv );
A = uint8( mat2gray(backImg)*maxv );

%figure,imshow(E,[]),title('d');
%figure,imshow(E,[]);
dir_E='D:\360MoveData\Users\LKOII\Desktop\loop_guidefilter\N1\';
%imwrite((E),[dir_E ['E_',num2str(index),'.png']]);
%% 
thresh = graythresh(E);     %自动确定二值化阈值
E2 = im2bw(E,thresh);       %对图像二值化
%figure,imshow(E2,[]),title('binary');

%% consistency verification
decisionMap=E2;
%disp('consistency verification......')
%small region removal
ratio1=0.0002;%it could be mannually adjusted according to the characteristic of source images
area1=ceil(ratio1*hei*wid);
tempMap1=bwareaopen(decisionMap,area1);%删除面积小于area的区域。
%figure,imshow(tempMap1,[]);title('tempmap1');
tempMap2=1-tempMap1;
%figure,imshow(tempMap2,[]);title('tempmap2');
%area2
tempMap3=bwareaopen(tempMap2,area1);
%figure,imshow(tempMap3,[]);title('tempmap3');
decisionMap=1-tempMap3;
dir_con='D:\360MoveData\Users\LKOII\Desktop\loop_guidefilter\N2\';
%imwrite((decisionMap),[dir_con ['REs',num2str(index),'.png']]);

%figure,imshow(decisionMap,[]);
%figure,imshow(decisionMap);


imgf_gray=img;
decisionMap = guidedfilter(imgf_gray,decisionMap,8,0.1);
dir_d1='D:\360MoveData\Users\LKOII\Desktop\3_ALL\result2\explain_decision\d1\';

if size(img,3)>1
    decisionMap=repmat(decisionMap,[1 1 3]);
end
flag=0;
%d1
d=decisionMap;
for i1=2:50
    
    iter(i1-1,1)=i1-1;
    %disp(iter);
    d_iter=d;
   thresh=graythresh(d);
   d_bin = im2bw(d,thresh);       %对图像二值化
   d = guidedfilter(imgf_gray,d_bin,8,0.1);
    d_iter1=d;
    if i1==44
    dir_ssim='D:\360MoveData\Users\LKOII\Desktop\3_ALL\result2\dmap_ssim\';
   % imwrite((d),[dir_ssim ['IR_',num2str(index),'.png']])
    end
    %figure,imshow(d_iter);
    %figure,imshow(d_iter1);
    M(i1-1,1)=ssim_index(d_iter,d_iter1);
    %axis([1,49,0.9996,1.0001])  %确定x轴与y轴框图大小S

    plot(i1-1,M(i1-1,1),'bx');
     %legend('SSIM(Iter,iter+1)');
    hold on;
   
   
  
          
end
%plot(1,M(1,1),'r*');
%legend('SSIM(I^{iter},I^{iter+1})','SSIM(1,2)');

 x=iter(:,1);
    y1=M(:,1);
    xx=linspace(1,49);
    yy1=spline(x,y1,xx);
    plot(xx,yy1,'b')
     %右上角标注
     %legend('SSIM(T^{1},I^{2})','SSIM(T^{2},I^{3})','SSIM(T^{3},I^{4})','SSIM(T^{4},I^{5})');
     %legend('SSIM(I^{iter},I^{iter+1})','SSIM(1,2)');
     p1=plot(1,M(1,1),'r*');
     p2=plot(2,M(2,1),'r*');
     p3=plot(3,M(3,1),'r*');
     p4=plot(4,M(4,1),'r*');
     p5=plot(49,M(49,1),'r*');
     legend([p1,p2,p3,p4,p5],'SSIM(T^{1},T^{2})','SSIM(T^{2},T^{3})','SSIM(T^{3},T^{4})','SSIM(T^{4},T^{5})','SSIM(T^{49},T^{50})');
    xlabel('iter')  %x轴坐标描述
    ylabel('SSIM(T^{iter+1},T^{iter})') %y轴坐标描述


    

end