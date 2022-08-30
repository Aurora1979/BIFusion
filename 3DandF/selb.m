function Y = selb(M1, M2, mp)
%Y = selb(M1, M2, mp) coefficient selection for base image
%
%    M1  - coefficients A
%    M2  - coefficients B
%    mp  - switch for selection type
%          mp == 1: select A
%          mp == 2: select B
%          mp == 3: average A and B
% 
%    Y   - combined coefficients

%    (Oliver Rockinger 16.08.99)

switch (mp)
  case 1, Y = M1;
  case 2, Y = M2;
  case 3, %figure;imshow(uint8(M1)),title('M1ตอฦต');
          %figure;imshow(uint8(M2));title('M2ตอฦต');
          Y = (M1 + M2) / 2;
          %figure;imshow(uint8(M1)),title('M1ตอฦต');
          %figure;imshow(uint8(M2));title('M2ตอฦต');
  case 4
%figure;imshow(uint8(M1)),title('M1ตอฦต');
%figure;imshow(uint8(M2));title('M2ตอฦต');
    lambda=10;
    mm = abs(M1);
    %m1=abs(M1);
    %m2=abs(M2);
    %R=max(m1-m2,0);
    R=mm;
    Emax = max(R(:));
    P = R/Emax;

    C = atan(lambda*P)/atan(lambda);
  	Y  = (C.*M1) + ((1-C).*M2);
  otherwise, error('unknown option');
end;




