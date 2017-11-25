function gamma = EdgeAwareWeighting(G)
% Eqn(5) in the paper
% G:    guidance image, must be a gray-scale image
% gamma:  weighting result

% L = 1; % dynamic range
L = max(max(G)) - min(min(G));
eps = (0.001*L)^2;
r = 1; % ´°¿Ú°ë¾¶(x-r:x+r, y-r:y+r)

[hei, wid] = size(G);
N = boxfilter(ones(hei, wid), r);

mean_G = boxfilter(G, r) ./ N;
mean_GG = boxfilter(G.*G, r) ./ N;
var_G = mean_GG - mean_G .* mean_G;     % variance

% Eqn(5)
var_G1 = var_G + eps;
var_G1_sum = sum(sum(1./var_G1));
gamma0 = var_G1 * var_G1_sum /hei/wid;

gamma = imgaussfilt(gamma0, 2);

end
