%% Demo of haze removal
% I_rgb = imread('.\img\forest.jpg');
I_rgb = imread('.\img\forest2.jpg');
% I_rgb = imread('.\img\river.jpg');

I_rgb = double(I_rgb) / 255;

epsilon = 7; %10;
I_min = min(I_rgb, [], 3);% + min_offset;
I_dark = MinFilter(I_min, epsilon);  % Eqn(23)

Ac = GetAirLight(I_rgb, I_dark, 0.98);

omega = 31/32;
t = 1 - omega * (I_dark./min(Ac));     % Eqn(27)

r = 60;
lambda = 1/1000;
G = rgb2gray(I_rgb);
t_smoothed = WeightedGuidedImageFilter(t, G, r, lambda);

haze_level = 0.03125; % 0(light), 0.03125(normal), 0.0625(heavy);
t_adjusted = t_smoothed .^(1+haze_level);   % Eqn(28)
amplify_factor0 = max(0.1, 1./t_adjusted - 1);
amplify_factor = repmat(amplify_factor0, 1,1,3);

[hei, wid, ~] = size(I_rgb);
Ac_rep = repmat(reshape(Ac, [1,1,3]), hei, wid);
Z = I_rgb + amplify_factor.*(I_rgb-Ac_rep);  % Eqn(30)

% figure();   imshow([rgb2gray(I_rgb),I_min,I_dark]);     title('I-gray, I-min, I-dark');
figure();   imshow([t, t_adjusted]);    title('t, t-adjusted');
figure();   imshow([I_rgb, Z]);     title('I-rgb, Z');












