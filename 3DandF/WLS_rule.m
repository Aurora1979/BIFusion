function [Fd] = WLS_rule(I1,I2)
sigma0 = 2.5;%2
w = floor(3*sigma0);
h = fspecial('gaussian', [2*w+1, 2*w+1], sigma0);   
C_0 = double(abs(I1) < abs(I2));
C_0 = imfilter(C_0, h, 'symmetric');
M = C_0.*I2 + (1-C_0).*I1;
lambda = 0.01;  %0.01
Fd = Solve_Optimal(M,I1,I2,lambda); 
%figure,imshow(pyr{l}),title('WLS');
end

