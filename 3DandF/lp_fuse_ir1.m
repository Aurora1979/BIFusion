function F = lp_fuse_ir1(M1, M2, imd)
flag=0;
ap=1;
IR=M1;
VI=M2;
%Y = fuse_lap(M1, M2, zt, ap, mp) image fusion with laplacian pyramid
%M1Ϊvis M2Ϊir
%    M1 - input image A
%    M2 - input image B
%    zt - maximum decomposition level(���ֽ⼶��/�ںϲ���)
%    ap - coefficient selection highpass (see selc.m) ����ͨϵ��ѡ��
%    mp - coefficient selection base image (see selb.m) ����ͼϵ��ѡ��
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
end;   %�ж�����ͼ�ߴ��Ƿ�һ��

% define filter �������˲�������˹��������
w  = [1 4 6 4 1] / 16;

%����ʹ�С

% cells for selected images
E = cell(1,zt);  %zt�ںϲ���cell ��������һ����Ϊ1��Ϊzt�Ŀ�����
% tic
% loop over decomposition depth -> analysis  ��ѭ���ֽ����->������
for i1 = 1:zt 
    
    tic     %tic���浱ǰʱ�䣬toc��¼�������ʱ��
  % calculate and store actual image size �����㲢�洢ʵ��ͼ���С��
  [z s]  = size(M1); 
  zl(i1) = z; sl(i1)  = s;%z1 s1 ��=256
 %disp('&&&&&&&&&&&&&&&&&&&&&&')
  %disp(z1);Դͼ��ĳߴ�
  %disp(s1);
  
  
  % check if image expansion necessary �����ͼ���Ƿ���Ҫ��չ/�ж���ż��
  if (floor(z/2) ~= z/2), ew(1) = 1; else, ew(1) = 0; end;%С���ţ��������������Ԫ�ء��� X(3)����X�ĵ�����Ԫ�ء� X([1 2 3])����X��ͷ����Ԫ�ء�
  if (floor(s/2) ~= s/2), ew(2) = 1; else, ew(2) = 0; end;

  % perform expansion if necessary ����Ҫʱִ����չ/������չΪż����
  if (any(ew))
  	M1 = adb(M1,ew);
  	M2 = adb(M2,ew);
  end;	

  % perform filtering ��ִ�й���/��ͨ�˲���%��ͨ�˲����ã�ģ��ͼ��
  G1 = conv2(conv2(es2(M1,2), w, 'valid'),w', 'valid'); %conv2��ά�����es2���б߽��ϵľ���Գ���չ
  G2 = conv2(conv2(es2(M2,2), w, 'valid'),w', 'valid');
  %figure;imshow(uint8(G1)),title('G1');
  %figure;imshow(uint8(G2)),title('G2');
  
 
  % decimate, undecimate and interpolate ��������δ����������ֵ/G1��G2�²������ϲ�����ͨ�˲�����������У�
  M1T = conv2(conv2(es2(undec2(dec2(G1)), 2), 2*w, 'valid'),2*w', 'valid');  %dec2�����ϲ��� ֮����Ҫ���²������ϲ�����Ŀ�����������Ұ
  M2T = conv2(conv2(es2(undec2(dec2(G2)), 2), 2*w, 'valid'),2*w', 'valid');%M1T��ģ�����֣�M1-M1T���ʾ��Ƶϸ����Ϣ
  
  
  %disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%the value of M1')
  %disp(size(M1))%��չ���M1 ������չΪż��
  %disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%the value of M1T')
  %disp(size(M1T))
  %M1T = conv2(conv2(es2(G1, 2), 2*w, 'valid'),2*w', 'valid');  %dec2�����ϲ���
  %M2T = conv2(conv2(es2(G2, 2), 2*w, 'valid'),2*w', 'valid');
  
  %figure;imshow(uint8(M1T)),title('2M1T');
  %figure;imshow(uint8(M2T)),title('2M2T');
  %vaild�����Ǳ߽粹�㣬��ֻҪ�б߽粹�������������Ķ���ȥ��
%   toc76

% tic
  % select coefficients and store them ��ѡ��ϵ�����洢/��Ƶ�Ӵ�ͼ��ϵ��ѡ��
 % FW1=lasheng(M1-M1T);
 % FW2=lasheng(M2-M2T);
%figure;imshow(uint8(FW1)),title('vis��Ƶ');
%figure;imshow(uint8(FW2)),title('ir��Ƶ');
MG2=M2-M2T;

%vis=imread
  %MG1=wmcFilter(M1-M1T,1);
  if(~flag)
  MG2=wmcFilter(MG2,1);
  disp('filter*************8');
  flag=flag+1;
  end
  %figure;imshow(uint8(lasheng(MG2))),title('WMC��ir��Ƶ');
 % disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%the value of MG1')
  %disp(size(MG1))
  
  %WMC_lose=M1-M1T-MG1;
  
  
  %figure;imshow(uint8(WMC_lose)),title('WMClose');
 % disp('*****************666')
  %disp(size(MG1))
  
  %MG1=wmcFilter(M1-M1T,2)
  %MG2=wmcFilter(M2-M2T,2)
 % E(i1) = {selc(M1-M1T,M2-M2T,ap)};%ԭͼҪ��ȥ��Ĥ
  E(i1) = {selc(M1-M1T,MG2,ap)};%fusion rule :max
  %E(i1)������ںϺ�ĸ�Ƶ
% toc
  % decimate 
%  tic  ���²�����
  M1 = dec2(G1);
  
  %disp('****************���������M1')
  %disp(size(M1)) %186 236
  
  M2 = dec2(G2);
  %figure;imshow(lasheng(M1)),title('�²������G1');
  %figure;imshow(lasheng(M2)),title('�²������G2');
%   toc
% toc
% feature ('memstats')

end;
% toc
% select base coefficients of last decompostion stage ����Ƶ�Ӵ�ͼ��ϵ��ѡ��
% tic
%figure;imshow(uint8(M1)),title('vis��Ƶ');
%figure;imshow(uint8(M2)),title('ir��Ƶ');
%M1=wmcFilter(M1,1)
%M2=wmcFilter(M2,1)
%wmc_lose=M1-MG1;

M1 = selb(M1,M2,3);%M1��ŵ����ںϺ�ĵ�Ƶ 3 Ϊfusion rule����average 4Ϊ�����л���Ȩ�صķ���
%M1=fusion_EA(M1,M2,0.05)
%figure;imshow(uint8(M1)),title('M1��Ƶ');

%M1 = selb(M1,M2,4);%fusion rule������������Ĳο�Ȩ�صķ���
% toc
% whos
% feature ('memstats')
% toc
% loop over decomposition depth -> synthesis  ��ͼ���ع���
% tic
for i1 = zt:-1:1
  % undecimate and interpolate 
%   tic
  M1T = conv2(conv2(es2(undec2(M1), 2), 2*w, 'valid'), 2*w', 'valid');
  
  % figure;imshow(uint8(M1T)),title('M1��Ƶ');
  %figure;imshow(lasheng(M1T)),title('M1��Ƶ');
  % add coefficients
  M1  = M1T + E{i1};
  %disp('******************')
  
  %disp(size(M1));
  %M1=M1+WMC_lose;
  
%   toc
  % select valid image region ��ѡ��ͼ����Ч����
  M1 	= M1(1:zl(i1),1:sl(i1));
  
 %disp('*******************88888888888')
 %disp(z1);
 %disp(s1);
  
  %disp(size(M1));
 %figure;imshow(uint8(M1)),title('M1��Ƶ');
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
C = size(u,3);%3��ʾͨ����
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
k=[1,1,0;2,-6,0;1,1,0]/6;%�������Ӧ�����kernel��h1
k2=[2,4,1;4,-12,0;1,0,0]/12;%kernel��h5
dist = zeros([size(u),8],'single');
dist(:,:,1) = conv2(u,k,'same');
%A:����ͼ��B:�����
%��������ͼ��A��СΪma x na�������B��СΪmb x nb����
%��shape=fullʱ������ȫ����ά��������������C�Ĵ�СΪ��ma+mb-1��x��na+nb-1��
%shape=sameʱ��������Aͬ����С�ľ�����Ĳ���
 %shape=validʱ�������Ǳ߽粹�㣬��ֻҪ�б߽粹�������������Ķ���ȥ������C�Ĵ�СΪ��ma-mb+1��x��na-nb+1��


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
dm = dist(index); %dist���Լ����������ж����������֮��ľ������

%% ��ʾ������������˹ͼ��  ʹ��Ҷ�ֵ��0-255
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









