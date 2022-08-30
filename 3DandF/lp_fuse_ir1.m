function F = lp_fuse_ir1(M1, M2, imd)
flag=0;
ap=1;
IR=M1;
VI=M2;
%Y = fuse_lap(M1, M2, zt, ap, mp) image fusion with laplacian pyramid
%M1为vis M2为ir
%    M1 - input image A
%    M2 - input image B
%    zt - maximum decomposition level(最大分解级别/融合层数)
%    ap - coefficient selection highpass (see selc.m) （高通系数选择）
%    mp - coefficient selection base image (see selb.m) （基图系数选择）
%
%    Y  - fused image   

%    (Oliver Rockinger 16.08.99)
% whos
% size(M2)
% M2_bin=im2bw(M2);
% size(M2_bin)
% M2_plase=M2.*M2_bin;
% 
% figure;imshow(uint8(M2_bin));
% figure;imshow(uint8(M2_plase));
zt=8;
% check inputs 
[z1 s1] = size(M1);
[z2 s2] = size(M2);
M1=im2double(M1);
M2=im2double(M2);
if (z1 ~= z2) | (s1 ~= s2)
  error('Input images are not of same size');
end;   %判断两幅图尺寸是否一致

% define filter （定义滤波器）高斯函数窗口
w  = [1 4 6 4 1] / 16;

%卷积和大小

% cells for selected images
E = cell(1,zt);  %zt融合层数cell 函数生成一个行为1列为zt的空数组
% tic
% loop over decomposition depth -> analysis  （循环分解深度->分析）
for i1 = 1:zt 
    
    tic     %tic保存当前时间，toc记录程序完成时间
  % calculate and store actual image size （计算并存储实际图像大小）
  [z s]  = size(M1); 
  zl(i1) = z; sl(i1)  = s;%z1 s1 都=256
 %disp('&&&&&&&&&&&&&&&&&&&&&&')
  %disp(z1);源图像的尺寸
  %disp(s1);
  
  
  % check if image expansion necessary （检查图像是否需要扩展/判断奇偶）
  if (floor(z/2) ~= z/2), ew(1) = 1; else, ew(1) = 0; end;%小括号，用于引用数组的元素。如 X(3)就是X的第三个元素。 X([1 2 3])就是X的头三个元素。
  if (floor(s/2) ~= s/2), ew(2) = 1; else, ew(2) = 0; end;

  % perform expansion if necessary （必要时执行扩展/奇数扩展为偶数）
  if (any(ew))
  	M1 = adb(M1,ew);
  	M2 = adb(M2,ew);
  end;	

  % perform filtering （执行过滤/低通滤波）%低通滤波作用：模糊图像
  G1 = conv2(conv2(es2(M1,2), w, 'valid'),w', 'valid'); %conv2二维卷积，es2所有边界上的矩阵对称扩展
  G2 = conv2(conv2(es2(M2,2), w, 'valid'),w', 'valid');
  %figure;imshow(uint8(G1)),title('G1');
  %figure;imshow(uint8(G2)),title('G2');
  
 
  % decimate, undecimate and interpolate （抽样，未经抽样，插值/G1与G2下采样、上采样低通滤波后的膨胀序列）
  M1T = conv2(conv2(es2(undec2(dec2(G1)), 2), 2*w, 'valid'),2*w', 'valid');  %dec2矩阵上采样 之所以要先下采样后上采样的目的是增大感受野
  M2T = conv2(conv2(es2(undec2(dec2(G2)), 2), 2*w, 'valid'),2*w', 'valid');%M1T是模糊部分，M1-M1T后表示高频细节信息
  
  
  %disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%the value of M1')
  %disp(size(M1))%扩展后的M1 奇数扩展为偶数
  %disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%the value of M1T')
  %disp(size(M1T))
  %M1T = conv2(conv2(es2(G1, 2), 2*w, 'valid'),2*w', 'valid');  %dec2矩阵上采样
  %M2T = conv2(conv2(es2(G2, 2), 2*w, 'valid'),2*w', 'valid');
  
  %figure;imshow(uint8(M1T)),title('2M1T');
  %figure;imshow(uint8(M2T)),title('2M2T');
  %vaild不考虑边界补零，即只要有边界补出的零参与运算的都舍去，
%   toc76

% tic
  % select coefficients and store them （选择系数并存储/高频子带图像系数选择）
 % FW1=lasheng(M1-M1T);
 % FW2=lasheng(M2-M2T);
%figure;imshow(uint8(FW1)),title('vis高频');
%figure;imshow(uint8(FW2)),title('ir高频');
MG2=M2-M2T;

%vis=imread
  %MG1=wmcFilter(M1-M1T,1);
  if(~flag)
  MG2=wmcFilter(MG2,1);
  disp('filter*************8');
  flag=flag+1;
  end
  %figure;imshow(uint8(lasheng(MG2))),title('WMC后ir高频');
 % disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%the value of MG1')
  %disp(size(MG1))
  
  %WMC_lose=M1-M1T-MG1;
  
  
  %figure;imshow(uint8(WMC_lose)),title('WMClose');
 % disp('*****************666')
  %disp(size(MG1))
  
  %MG1=wmcFilter(M1-M1T,2)
  %MG2=wmcFilter(M2-M2T,2)
 % E(i1) = {selc(M1-M1T,M2-M2T,ap)};%原图要减去掩膜
  E(i1) = {selc(M1-M1T,MG2,ap)};%fusion rule :max
  %E(i1)存的是融合后的高频
% toc
  % decimate 
%  tic  （下采样）
  M1 = dec2(G1);
  
  %disp('****************降采样后的M1')
  %disp(size(M1)) %186 236
  
  M2 = dec2(G2);
  %figure;imshow(lasheng(M1)),title('下采样后的G1');
  %figure;imshow(lasheng(M2)),title('下采样后的G2');
%   toc
% toc
% feature ('memstats')

end;
% toc
% select base coefficients of last decompostion stage （低频子带图像系数选择）
% tic
%figure;imshow(uint8(M1)),title('vis低频');
%figure;imshow(uint8(M2)),title('ir低频');
%M1=wmcFilter(M1,1)
%M2=wmcFilter(M2,1)
%wmc_lose=M1-MG1;

M1 = selb(M1,M2,3);%M1存放的是融合后的低频 3 为fusion rule采用average 4为文献中基于权重的方法
%M1=fusion_EA(M1,M2,0.05)
%figure;imshow(uint8(M1)),title('M1低频');

%M1 = selb(M1,M2,4);%fusion rule采用文献提出的参考权重的方法
% toc
% whos
% feature ('memstats')
% toc
% loop over decomposition depth -> synthesis  （图像重构）
% tic
for i1 = zt:-1:1
  % undecimate and interpolate 
%   tic
  M1T = conv2(conv2(es2(undec2(M1), 2), 2*w, 'valid'), 2*w', 'valid');
  
  % figure;imshow(uint8(M1T)),title('M1低频');
  %figure;imshow(lasheng(M1T)),title('M1低频');
  % add coefficients
  M1  = M1T + E{i1};
  %disp('******************')
  
  %disp(size(M1));
  %M1=M1+WMC_lose;
  
%   toc
  % select valid image region （选择图像有效区域）
  M1 	= M1(1:zl(i1),1:sl(i1));
  
 %disp('*******************88888888888')
 %disp(z1);
 %disp(s1);
  
  %disp(size(M1));
 %figure;imshow(uint8(M1)),title('M1低频');
%   feature ('memstats')
% whos
end;

% feature ('memstats')
% copy image
%vis=imread('019_vis.jpg')
%vis=vis-MG1
%disp('**********************');
%disp(size(M1));
%disp(size(WMC_lose));
%if size(M1)~=size(WMC_lose)
%M1(371+1,:)=0;
%M1(:,359+1)=0;

    
%disp(WMC_lose)
%M1=M1+WMC_lose;


preF = M1;
ir_target=IR.*imd;
figure,imshow(ir_target,[]);
figure,imshow(preF.*double((1-imd)),[]),title('pre')
F=preF.*double((1-imd))+double( ir_target);


%M1 VIS M2 IR

%disp('***************************************')
%disp(size(Y))


% toc

%%
function result = wmcFilter(im,iteration)
%weighted mean curvature filter, implemented by Yuanhao Gong
%{ 
@article{GONG2019,
title = "Weighted mean curvature",
journal = "Signal Processing",
volume = "164",
pages = "329 - 339",
year = "2019",
issn = "0165-1684",
doi = "https://doi.org/10.1016/j.sigpro.2019.06.020",
url = "http://www.sciencedirect.com/science/article/pii/S0165168419302282",
author = "Yuanhao Gong and Orcun Goksel",}
%}
u = single(im);
N = size(u,1)*size(u,2); 
C = size(u,3);%3表示通道数
%************************************
%disp('****************************')
%disp(C)
offset=int32(reshape(-(N-1):0,size(u,1),size(u,2)));
for ch=1:C %discrete weighted mean curvature filter on each color channel
    for i=1:iteration
        tmp = wmc(u(:,:,ch),offset);
        u(:,:,ch) = u(:,:,ch) + tmp;
    end
end
result = uint8(u);
result = double(result)/255;
%% compute discrete weighted mean curvature
function dm=wmc(u,offset)
k=[1,1,0;2,-6,0;1,1,0]/6;%文献里对应的相关kernel核h1
k2=[2,4,1;4,-12,0;1,0,0]/12;%kernel核h5
dist = zeros([size(u),8],'single');
dist(:,:,1) = conv2(u,k,'same');
%A:输入图像，B:卷积核
%假设输入图像A大小为ma x na，卷积核B大小为mb x nb，则
%当shape=full时，返回全部二维卷积结果，即返回C的大小为（ma+mb-1）x（na+nb-1）
%shape=same时，返回与A同样大小的卷积中心部分
 %shape=valid时，不考虑边界补零，即只要有边界补出的零参与运算的都舍去，返回C的大小为（ma-mb+1）x（na-nb+1）


dist(:,:,2) = conv2(u,fliplr(k),'same');
dist(:,:,3) = conv2(u,k','same');
dist(:,:,4) = conv2(u,flipud(k'),'same');
dist(:,:,5) = conv2(u,k2,'same');
dist(:,:,6) = conv2(u,fliplr(k2),'same');
dist(:,:,7) = conv2(u,flipud(k2),'same');
dist(:,:,8) = conv2(u,rot90(k2,2),'same');
tmp = abs(dist); %to find the signed minimum absolute distance
[~,ind] = min(tmp,[],3); %turn sub to index, but faster than sub2ind
index = int32(ind)*int32(size(dist,1)*size(dist,2))+offset;
dm = dist(index); %dist可以计算样本集中多个样本两两之间的距离矩阵。

%% 显示拉伸后的拉普拉斯图像  使其灰度值在0-255
function L=lasheng(M)
    [m,n]=size(M)
    
     min = M(1);
     max = M(1);
    for i=1:m
        for j=1:n
            if(min>M(i,j))
                min=M(i,j)
            end;
            if(max<M(i,j))
                max=M(i,j)
            end
        end
    end
    for i=1:m
        for j=1:n
            L(i,j)=(255*(M(i,j)-min)/(max-min));
        end
    end









