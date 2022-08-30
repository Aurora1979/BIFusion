function [ mean ] = absulate_mean(imgpluse)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
    [m1,n1]=size(imgpluse);
    count=0;
    sum=0;
    for i1=1:m1
          for j1=1:n1
              if imgpluse(i1,j1)~=0
                  count=count+1;
                  sum=sum+imgpluse(i1,j1);
                  %disp(count);
              end
              
            %  disp('&*****************************88');
             % disp(test_img(i1,j1));
             % disp(sum);
              
          end
    end
      mean=sum/count;

end


