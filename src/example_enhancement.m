% example: detail enhancement
% figure 6 in our paper

close all;

I = double(imread('.\img\tulips.bmp')) / 255;
p = I;

r = 16;
eps = 0.1^2;
theta = 4;

q = zeros(size(I));

q(:, :, 1) = guidedfilter(I(:, :, 1), p(:, :, 1), r, eps);
q(:, :, 2) = guidedfilter(I(:, :, 2), p(:, :, 2), r, eps);
q(:, :, 3) = guidedfilter(I(:, :, 3), p(:, :, 3), r, eps);

I_enhanced = (I - q) * theta + q;

figure('Name','GIF detail enhancement');
% imshow([I, q, I_enhanced], [0, 1]);
imshow([I, (I-q)*2+q, (I-q)*4+q, (I-q)*8+q]);