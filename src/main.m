%% WGIF full detail enhancement

% I = imread('..\img\tulips.bmp');
%I = imread('..\img\bird.jpg');
I = imread('..\img\sky.jpg');
% Ig = rgb2gray(I);
X = double(I)/255;

r = 16;
lambda = 1/128;
theta = 4;

Z = zeros(size(X));
Z(:,:,1) = WeightedGuidedImageFilter(X(:,:,1), X(:,:,1), r, lambda);
Z(:,:,2) = WeightedGuidedImageFilter(X(:,:,2), X(:,:,2), r, lambda);
Z(:,:,3) = WeightedGuidedImageFilter(X(:,:,3), X(:,:,3), r, lambda);

X_enhanced = (X-Z)*theta + Z;

% figure('Name', 'img in');
% imshow(X);
figure('Name', 'WGIF detail enhancement');
% imshow([X,(X-Z)*2+Z, (X-Z)*4+Z, (X-Z)*8+Z]);
imshow([X, Z, X_enhanced]);


%% WGIF selective detail enhancement

I = imread('..\img\tulips.bmp');
%I = imread('..\img\sky.jpg');
% Ig = rgb2gray(I);
X = double(I)/255;

r = 16;
lambda = 1/128;

Z = zeros(size(X));
gamma0 = zeros(size(X));
gamma = zeros(size(X));
for a = 1:3
    gamma0(:,:,a) = EdgeAwareWeighting(X(:,:,a));
    gamma1 = gamma0(:,:,a) / max(max(gamma0(:,:,a)));     % 归一化
    gamma_bw = AdaptiveThreshold(gamma1, 2*r, 4);         % 局部自适应二值化
    gamma(:,:,a) = gamma1 .* ~gamma_bw + gamma_bw;
    Z(:,:,a) = WGIF_(X(:,:,a), X(:,:,a), r, lambda, gamma0(:,:,a));     % 图像平滑
end

X_detail = X - Z;
X_enhanced = X_detail * 4 + X;              % full enhancement
X_enhanced2 = X_detail .* gamma * 4 + X;    % selective enhancement

% figure('Name', 'in --- WGIF_out');
% imshow([X,Z]);
figure('Name', 'in --- full --- selective');
imshow([X,X_enhanced, X_enhanced2]); 

%% WGIF selective detail enhancement  gray

I = imread('..\img\tulips.bmp');
% I = imread('..\img\sky.jpg');
Ig = rgb2gray(I);
X = double(Ig)/255;

r = 16;
lambda = 1/128;

gamma0 = EdgeAwareWeighting(X);

Z = WGIF_(X,X,r,lambda, gamma0);

X_detail = X - Z;


% 通过二值化削峰
gamma1 = gamma0 / max(max(gamma0));
gamma_bw = AdaptiveThreshold(gamma1, 2*r, 4);
gamma_wb = ~gamma_bw;
gamma2 = gamma1 .* gamma_wb;
gamma3 = gamma2 + gamma_bw;
gamma = gamma3;


% v2, 归一化
% 只能增强少部分边缘
% gamma = gamma0 / max(max(gamma0));

%{
1. 只对gamma进行归一化： 只能增强少部分边缘
2. 通过阀值1对gamma二值化然后削峰：噪声也会被增强，其效果与全局增强没区别
3. 通过全局二值化对gamma进行削峰：没试过
4. 通过局部自适应二值化对gamma进行削峰：目前效果最佳，只增强部分边缘， 但美中不足的是部分噪声也会被增强
%}


figure();
subplot(121);   imshow(gamma);     title('gamma');
subplot(122);   imhist(uint8(gamma*255));   title('histgram of gamma');

X_enhanced = X_detail * 4;
X_enhanced2 = X_detail .* gamma * 4;

figure('Name', 'WGIF');
imshow([X,Z]);
figure('Name', 'WGIF selective detail enhancement');
imshow([X_enhanced,X_enhanced2]);

%% edge aware wgighting
% I = imread('..\img\tulips.bmp');
% I = imread('..\img\bird.jpg');
I = imread('..\img\sky.jpg');
Ig = rgb2gray(I);
X = double(Ig)/255;
G = X;

% L = max(max(X))/min(min(X)); % dynamic range
L = max(max(X)) - min(min(X));
eps = (0.001*L)^2;
r = 1; % 窗口半径(x-r:x+r, y-r:y+r)

[hei, wid] = size(G);
N = boxfilter(ones(hei, wid), r);

mean_G = boxfilter(G, r) ./ N;
mean_GG = boxfilter(G.*G, r) ./ N;
var_G0 = mean_GG - mean_G .* mean_G;     % variance

var_G = var_G0 / max(max(var_G0));      % 将局部方差归一化

% Eqn(5)
var_G1 = var_G + eps;
var_G1_sum = sum(sum(1./var_G1));
gamma0 = var_G1 * var_G1_sum /hei/wid;
gamma = imgaussfilt(gamma0, 2);
gamma2 = gamma/ max(max(gamma));

figure('Name', 'edge aware weighting 1');
subplot(121);   imshow(X);         title('X');
subplot(122);   imshow(gamma2);     title('gamma2');
figure('Name', 'edge aware weighting 2');
subplot(121);   imshow(gamma0);       title('gamma0');
subplot(122);   imshow(gamma);        title('gamma');
%% GIF v.s. WGIF

% I = imread('..\img\tulips.bmp');
I = imread('..\img\sky.jpg');
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





