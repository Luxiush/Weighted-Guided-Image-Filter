%基于积分图的Wellner算法 局部自适应二值化
function img_bin = imgAdaptiveThreshold(img_in)
    img_in = uint32(img_in);
    [s.height,s.width] = size(img_in);
    img_bin = logical(uint8(zeros(s.height,s.width))); 
%% 计算积分图
    img_inter = zeros(s.height,s.width); 
    for r = 1:s.height
        sum = 0;
       for c = 1:s.width
           sum = sum + img_in(r,c);
           if(r==1)
              img_inter(r,c) = sum; 
           else
               img_inter(r,c) = sum + img_inter(r-1,c);
           end
       end
    end

%%
    window_size = round((min(s.height,s.width))/10);%窗口大小
    for r = 1:s.height
       for c = 1:s.width
           x1 = c-window_size; x2 = c+window_size;
           y1 = r-window_size; y2 = r+window_size;
           %边界检查
           if(x1<1), x1 = 1; end
           if(x2>s.width), x2 = s.width; end
           if(y1<1), y1 = 1; end
           if(y2>s.height), y2 = s.height; end
           
           count = (x2-x1)*(y2-y1);
           sum = img_inter(y2,x2)-img_inter(y1,x2)-img_inter(y2,x1)+img_inter(y1,x1);
           if(img_in(r,c)*count<sum*(100-4)/100)%低于均值的 x%
               img_bin(r,c) = 0;
           else
               img_bin(r,c) = 1;
           end
       end
    end
end