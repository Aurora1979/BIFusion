
function L=lashen(M)
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






