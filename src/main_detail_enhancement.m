%% selective detail enhancement v.s full detail enhancement

I = imread('.\img\tulips.bmp');
% I = imread('.\img\sky.jpg');
% I = imread('.\img\bird.jpg');
% Ig = rgb2gray(I);
X = double(I)/255;

r = 16;
lambda = 1/128;
theta = 4;

X_full = FullDetailEnhancement(X, r, lambda, theta);
X_selective = SelectiveDetailEnhancement(X, r, lambda, theta);

figure('Name', 'in --- full --- selective');
imshow([X,X_full, X_selective]); 
