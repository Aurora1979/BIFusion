function [rgb] = gray2rgb(img)
[rows,cols]=size(img);
 r=zeros(rows,cols);
 g=zeros(rows,cols);
 b=zeros(rows,cols);
 r=double(img);
 g=double(img);
 b=double(img);
 rgb=uint8(cat(3,r,g,b));
 
 %imwrite(uint8(rgb),'mdb025-rgb.jpg');
end

