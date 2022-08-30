function F= sele_lambda(IR,VI,imd)
%用来调节可见光在融合图像中的比重，lambda越大，红外信息越多。
%参考Hybrid-MSD
%对于多个目标 通过较小的M值来进行分割
%% ML1L0 decomp

lambda1 = 0.3;  
lambda2 = lambda1*0.01;
lambda3 = 0.1;

[IRB,IRD]=Layer_decomp(IR,lambda1,lambda2,lambda3);
[VIB,VID]=Layer_decomp(VI,lambda1,lambda2,lambda3);

weight1 = Visual_Weight_Map(IR);
weight2 = Visual_Weight_Map(VI);
%figure,imshow(weight1,[]);
%figure,imshow(weight2,[]);

%% 
%figure,imshow(VID{4},[]);
%imwrite(IRB,patha1);
%imwrite(IRD{1},[],patha3);
%imwrite(IRD{2},[],patha4);
%imwrite(IRD{3},[],patha5);
%imwrite(IRD{4},patha6);
%imwrite(VID{1},patha7);
%imwrite(VID{2},patha8);
%imwrite(VID{3},patha9);
%imwrite(VID{4},patha10);


%% baselayer fusion

F_B=(0.5+0.5*(weight1-weight2)).*IRB + (0.5+0.5*(weight2-weight1)).*VIB;
%F_B=WLS_rule(IR,VI);
%figure,imshow(F_B),title('fb');
%% detaillayer fusion


for i=1:2
  F_D{i}=fuseVIS3(IRD{i} ,VID{i},1000000000000);
  
  
  %figure,imshow(F_D{i},[]);
end

preF=F_B+F_D{1}+F_D{2};

%preF=F_B+F_D{1}+F_D{2}+F_D{3}+F_D{4};
%figure,imshow(preF),title('pre')
%figure,imshow(imd);
ir_target=IR.*imd;
%figure,imshow(ir_target);
F=preF.*double((1-imd))+double( ir_target);


%F1=uint8((F-min(F(:)))./(max(F(:))-min(F(:)))*255);
%figure,imshow(F1),title('F');
%figure,imshow(F1,[]),title('F');
end





