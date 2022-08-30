function Y = fuseVIS6(M1, M2)
%
%²Î¿¼Hybrid-MSD
% check inputs 
%%
 %lambda=30;
  b1 = abs(M1);
  b2 = abs(M2);
  R_j = max(b1-b2, 0);
  Emax = max(R_j(:));
  P_j = R_j/Emax;
  C_j = P_j;
  sigma0 = 1.0;
  w = floor(3*sigma0);
  h = fspecial('gaussian', [2*w+1, 2*w+1], sigma0);   
  C_j = imfilter(C_j, h, 'symmetric');
  %figure,imshow(C_j);
  Y  = (C_j.*M1) + ((1-C_j).*M2);
