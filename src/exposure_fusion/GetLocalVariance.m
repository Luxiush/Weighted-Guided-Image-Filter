function var = GetLocalVariance(I, r)
% get local variance of a gray-scale image.
% I: a gray-scal image
% r: window radius

    [hei, wid] = size(I);
    N = boxfilter(ones(hei, wid), r);
    mean_I = boxfilter(I, r) ./ N;
    mean_II = boxfilter(I.*I, r) ./ N;
    var = mean_II - mean_I .* mean_I;
end