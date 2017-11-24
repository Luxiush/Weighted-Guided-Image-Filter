% exposure fusion
addpath('exposure_fusion');
I = load_images('.\img\house');
[hei, wid, channels, num] = size(I);

%%

I_gray = zeros(hei, wid, num);
var_I = zeros(hei, wid, num);      % local variance in log domain
omega = zeros(hei, wid, num);
for n = 1:num
    I_gray(:,:,n) = rgb2gray(I(:,:,:,n));
    %var_I(:,:,n) = GetLocalVariance(log(I_gray(:,:,n)), 1);     % 局部方差的计算结果中会出现NaN ？？？ log 在搞鬼
    var_I(:,:,n) = GetLocalVariance(I_gray(:,:,n), 1); 
    omega(:,:,n) = 77/255*FuncGamma(I(:,:,1,n)) + 150/255*FuncGamma(I(:,:,2,n)) + 29/255*FuncGamma(I(:,:,3,n));
end

% Eqn(32), overall local variance
sigma = sum(omega.*(var_I+0.001), 3) ./ (sum(omega, 3)+10e-13);

% Eqn(34)
Gamma = sum(sum(1./sigma/ hei / wid)) * sigma;

% fine details
Lk = zeros(hei, wid, num);
for n2 = 1:num
%     Lk(:,:,n2) = WGIF_(I_gray(:,:,n2), I_gray(:,:,n2), 16, 1/128, Gamma);
     Lk(:,:,n2) = I_gray(:,:,n2) - WGIF_(I_gray(:,:,n2), I_gray(:,:,n2), 16, 1/4, Gamma);
%    Lk(:,:,n2) = WeightedGuidedImageFilter(Gamma, I_gray(:,:,n2), 16, 1/4);
end

% 先用论文中所提的wgif算法从每张图像中获取一定的细节，然后再将所有的细节合并
% 这里得到的是曝光度良好的图像细节，最后将这些图像细节整合到中间图像中得到最终的图像。
L = sum(Lk.*omega, 3)./sum(omega, 3);  % Eqn(35)   

%%
I_int = exposure_fusion(I, [1,1,1]);
chi = 1;
I_out = I_int .* exp(repmat(chi*L, [1,1,3]));
%I_out = I_int .* repmat(chi*L, [1,1,3]);
figure(); imshow(I_out);


