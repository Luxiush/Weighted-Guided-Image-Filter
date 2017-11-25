function Ac = GetAirLight(I_rgb, I_dark, percentage)
% get the Ac parameter of Equ(15)
% 先从暗通道中获取最亮的点（不止一个）的坐标，然后在每个颜色通道上对这些坐标上的值求均值

I_brightest = im2bw(I_dark, percentage*max(max(I_dark)));
count = length(find(I_brightest));

Ac = [0,0,0];
for c = 1:3
    sum_brightest = sum(sum(I_rgb(:,:,c).*I_brightest));
    Ac(c) = sum_brightest/count;
end

end