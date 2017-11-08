function I_min = ChannelMin(I_rgb)
% I_min(i,j) = min(I_rgb(i,j,1), I_rgb(i,j,2), I_rgb(i,j,3))

I_min = min(I_rgb, [], 3);

end