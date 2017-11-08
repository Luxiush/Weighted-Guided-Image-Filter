function I_dark = GetDarkChannel(I_rgb, r)
% Get the dark channel of a RGB image 
% I_rgb:        RGB image 
% r:            window radius
% I_dark:       dark channel

I_min = min(I_rgb, [], 3);

[hei, wid] = size(I_min);

I_padded = padarray(I_min, [r r], Inf);

I_dark = zeros(hei, wid);
for i = 1:hei 
    for j = 1:wid
        I_dark(i,j) = min(min(I_padded(i:i+2*r, j:j+2*r)));
    end
end

end