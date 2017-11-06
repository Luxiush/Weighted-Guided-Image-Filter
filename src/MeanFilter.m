% 基于boxfilter的均值滤波器
function mean = MeanFilter(img, r)
    N = boxfilter(ones(size(img)), r);
    mean = boxfilter(img, r) ./ N;
end