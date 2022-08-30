function d_bin = d_set1(d)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
thresh=graythresh(d);
 d_bin = im2bw(d,thresh);  




end

