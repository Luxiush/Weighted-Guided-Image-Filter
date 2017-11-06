function Z = WeightedGuidedImageFilter(X, G, r, lambda)
% X:        input image
% G:        guidance image, must be a gray-scale image
% r:        window radius
% lambda:   regularization parameter
% Z:        output image

gamma_G = EdgeAwareWeighting(G);
Z = WGIF_(X,G,r,lambda,gamma_G);
end