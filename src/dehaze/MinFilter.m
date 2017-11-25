function I_min = MinFilter(I, r)
% I_min(i,j) = min(min(I(i-r:i+r, j-r:j+r)))
% I:     single channel image
% r:     window radius

[hei, wid] = size(I);

I_padded = padarray(I, [r r], Inf);

I_min = zeros(hei, wid);
for i = 1:hei           % ordfilt2
    for j = 1:wid
        I_min(i,j) = min(min(I_padded(i:i+2*r, j:j+2*r)));
    end
end

end