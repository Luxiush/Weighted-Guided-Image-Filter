%% GIF v.s. WGIF

% I = imread('.\img\tulips.bmp');
I = imread('.\img\sky.jpg');
% I = imread('.\img\forest.jpg');
% Ig = rgb2gray(I);
X = double(I)/255;

r = 15;
lambda = 1/64;

Z_WGIF = zeros(size(X));
Z_WGIF(:,:,1) = WeightedGuidedImageFilter(X(:,:,1), X(:,:,1), r, lambda);
Z_WGIF(:,:,2) = WeightedGuidedImageFilter(X(:,:,2), X(:,:,2), r, lambda);
Z_WGIF(:,:,3) = WeightedGuidedImageFilter(X(:,:,3), X(:,:,3), r, lambda);

Z_GIF = zeros(size(X));
Z_GIF(:,:,1) = guidedfilter(X(:,:,1), X(:,:,1), r, lambda);
Z_GIF(:,:,2) = guidedfilter(X(:,:,2), X(:,:,2), r, lambda);
Z_GIF(:,:,3) = guidedfilter(X(:,:,3), X(:,:,3), r, lambda);

%% 
figure('Name', 'GIF v.s. WGIF');
imshow([X, Z_GIF, Z_WGIF]);

zg_GIF = rgb2gray(Z_GIF);
zg_WGIF = rgb2gray(Z_WGIF);
zg_X = rgb2gray(X);
figure('Name', 'GIF v.s. WGIF gray scale');
imagesc([zg_X, zg_GIF, zg_WGIF]);

l_G = zg_GIF(510,:);
l_W = zg_WGIF(510,:);
l_X = zg_X(510,:);
figure('Name', 'plot');
plot(l_X, 'Color', [1,0,0]); hold on;
plot(l_G, 'Color', [0,1,0]); hold on;
plot(l_W, 'Color', [0,0,1]); hold on;
legend('input', 'GIF', 'WGIF');

