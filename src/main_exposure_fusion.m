% exposure fusion
addpath('exposure-fusion-master');

I = load_images('.\img\house');

L = GetFineDetail(I);
I_int = exposure_fusion(I, [1,1,1]);
chi = 1;
I_out = I_int .* exp(repmat(chi*L, [1,1,3]));
figure(); imshow(L); title('fine details');
figure(); imshow(I_int); title('intermedia image');
figure(); imshow(I_out); title('fusion result');


