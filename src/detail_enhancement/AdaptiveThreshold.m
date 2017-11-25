function img_bin = AdaptiveThreshold(img_in, r, percent)
% 局部自适应二值化
%{
% I = imread('.\img\sky.jpg');
I = imread('.\img\tulips.bmp');
Ig = rgb2gray(I);
img_in = double(Ig)/255;
r = 8;
percent = 0.85;
%}

[hei, wid] = size(img_in);
img_inter = boxfilter(img_in, r);
N = boxfilter(ones(hei,wid), r);
img_mean = img_inter ./ N;

img_bin0 = img_in - img_mean*percent;
img_bin = im2bw(img_bin0, 0);

% figure('Name', 'img_in --- img_bin'); imshow([img_in,img_bin]); title(['r=', num2str(r), ',percent=', num2str(percent)]);
end