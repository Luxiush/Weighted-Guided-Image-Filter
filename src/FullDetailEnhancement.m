function X_enhanced = FullDetailEnhancement(X, r, lambda, theta)
% full detail enhancment
% X:    img in, double
% r:    window radius
% lambda:   regularization parameter
% theta:    amplify factor

[hei, wid, channels] = size(X);

Z = zeros(hei, wid, channels);
for c = 1:channels
    Z(:,:,c) = WeightedGuidedImageFilter(X(:,:,c), X(:,:,c), r, lambda);
end

X_enhanced = (X-Z) * theta + Z;
end