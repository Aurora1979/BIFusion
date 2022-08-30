%计算指标LOE
for i=1:21
index =i;
path1 = ['D:\matlabworkplace\superpixel_test\light_en\light2\Low-light-Imaging-main\iv\VIS',num2str(index),'.png'];
VI = imread(path1);
path2=['D:\360MoveData\Users\LKOII\Desktop\3_ALL\result1\LN\原文献统一2.2结果\VIS_',num2str(index),'.png'];
EN=imread(path2);
path3=['D:\360MoveData\Users\LKOII\Desktop\3_ALL\result1\LN\原文献统一2.2结果\LOE\LOE_',num2str(index),'.png'];
[loe,mask]=loe100x100(VI,EN);
T(i,1)=loe;
%disp(loe);
%imwrite(mask/256,path3)
%figure,imshow(mask,[]);
end