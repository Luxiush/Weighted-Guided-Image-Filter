function X_enhanced = SelectiveDetailEnhancement(X, r, lambda, theta)
% selective detail enhancment
% X:    img in, double
% r:    window radius (for wgif)
% lambda:   regularization parameter (for wgif)
% theta:    amplify factor

addpath('detail_enhancement');

[hei, wid, channels] = size(X);
r2 = floor(min(hei, wid) / 3);

Z = zeros(size(X));
gamma = zeros(size(X));
eta = zeros(size(X));
for a = 1:channels
    gamma(:,:,a) = EdgeAwareWeighting(X(:,:,a));
    gamma1 = gamma(:,:,a) / max(max(gamma(:,:,a)));     % 归一化
    gamma_bw = AdaptiveThreshold(gamma1, r2, 4);        % 局部自适应二值化
    eta(:,:,a) = gamma1 .* ~gamma_bw + gamma_bw;        % 削峰
    Z(:,:,a) = WeightedGuidedImageFilter(X(:,:,a), X(:,:,a), r, lambda, gamma(:,:,a));     % 图像平滑
end

X_enhanced = (X - Z) .* eta * theta + X;

end

%% ------------
%{
%% WGIF selective detail enhancement  gray

% I = imread('.\img\tulips.bmp');
I = imread('.\img\sky.jpg');
Ig = rgb2gray(I);
X = double(Ig)/255;

r = 16;
lambda = 1/128;

gamma0 = EdgeAwareWeighting(X);

Z = WGIF_(X,X,r,lambda, gamma0);

X_detail = X - Z;


% 通过二值化削峰
[hei, wid] = size(X);
r2 = floor(min(hei, wid) / 3);
gamma1 = gamma0 / max(max(gamma0));
gamma_bw = AdaptiveThreshold(gamma1, r2, 4);
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
2.1. 直接用二值化后的gamma, 
2.1.1. 用阈值1对gamma进行二值化，效果不理想，与全局没区别，
2.1.2. 用局部自适应二值化对gamma二值化，有点希望，但是有些噪声还需要进一步处理
3. 通过全局二值化对gamma进行削峰：没试过
4. 通过局部自适应二值化对gamma进行削峰：目前效果最佳，只增强部分边缘， 但美中不足的是部分噪声也会被增强,
可以通过调整局部自适应二值化的窗口半径来调整。
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
%}