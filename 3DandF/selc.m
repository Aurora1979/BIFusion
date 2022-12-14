function Y = selc(M1, M2, ap)
%Y = selc(M1, M2, ap) coefficinet selection for highpass components
%高通分量系数选择
%
%    M1  - coefficients A
%    M2  - coefficients B
%    mp  - switch for selection type 切换选择类型
%          mp == 1: choose max(abs) 选择绝对值最大
%          mp == 2: salience / match measure with threshold == .75 (as proposed by Burt et al)
%          mp == 3: choose max with consistency check (as proposed by Li et
%          al)用一致性检查选择最大
%          mp == 4: simple choose max 最大值
%
%    Y   - combined coefficients

%    (Oliver Rockinger 16.08.99)

% check inputs 
lambda=0.5;
[z1 s1] = size(M1);
[z2 s2] = size(M2);
if (z1 ~= z2) | (s1 ~= s2)
  error('Input images are not of same size');
end;

% switch to method
switch(ap(1))
 	case 1, 
 		% choose max(abs)
       % disp('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
     %L1=lasheng(M1);
     %L2=lasheng(M2);
     

        
%figure;imshow(uint8(L1)),title('拉伸后的拉普拉斯图');
%figure;imshow(uint8(L2)),title('拉伸后的拉普拉斯图');
       %disp('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
 		mm = (abs(M1)) > (abs(M2));
  	Y  = (mm.*M1) + ((~mm).*M2);%高频max fusion rule
 
 	case 2,
  	% Burts method 
  	um = 3; th = .75;
  	% compute salience 计算显著性
  	S1 = conv2(es2(M1.*M1, floor(um/2)), ones(um), 'valid'); 
  	S2 = conv2(es2(M2.*M2, floor(um/2)), ones(um), 'valid'); %ones函数产生一个全1矩阵
  	% compute match 
  	MA = conv2(es2(M1.*M2, floor(um/2)), ones(um), 'valid');
  	MA = 2 * MA ./ (S1 + S2 + eps);
  	% selection 
    m1 = MA > th; m2 = S1 > S2; 
    w1 = (0.5 - 0.5*(1-MA) / (1-th));
    Y  = (~m1) .* ((m2.*M1) + ((~m2).*M2));
    Y  = Y + (m1 .* ((m2.*M1.*(1-w1))+((m2).*M2.*w1) + ((~m2).*M2.*(1-w1))+((~m2).*M1.*w1)));
  	
  case 3,	       
  	% Lis method 
  	um = 3;
    % first step
  	A1 = ordfilt2(abs(es2(M1, floor(um/2))), um*um, ones(um));%二维顺序统计量滤波将n个非零数值按小到大排序后处于第k个位置的元素作为滤波器的输出
  	A2 = ordfilt2(abs(es2(M2, floor(um/2))), um*um, ones(um));
    % second step
  	mm = (conv2(double((A1 > A2)), ones(um), 'valid')) > floor(um*um/2);
  	Y  = (mm.*M1) + ((~mm).*M2);
 
  case 4, 
  	% simple choose max 
  	mm = M1 > M2;
  	Y  = (mm.*M1) + ((~mm).*M2);
  case 5,
    %my method
    m1 = abs(M1);
    m2 = abs(M2);
    if(m1>m2)
    R=m1;
    else
        R=m2;
    end
    %figure,imshow(R,[]),title('R')
    Emax = max(R(:));
    P = R/Emax;

    C = atan(lambda*P)/atan(lambda);
  	Y  = (C.*M1) + ((1-C).*M2);
  otherwise,
  	error('unkown option');
end;  
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
            
            
    
        







