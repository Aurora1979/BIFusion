function d_bin = d_set1(d)
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
thresh=graythresh(d);
 d_bin = im2bw(d,thresh);  




end

