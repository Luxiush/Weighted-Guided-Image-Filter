function gamma = FuncGamma(I)
% Eqn(33) in the paper
%                 / I(i,j) + 1 , if i<= 127
%   gamma(i,j) = |  
%                 \ 256 - I(i,j) , otherwise 
%{
I_bw = im2bw(I, 127/255);
gamma_0 = (I+1/255);
gamma_1 = (256/255-I);
%}
[hei, wid] = size(I);
gamma = zeros(hei, wid);
for h = 1:hei
   for w = 1:wid
       if(I(h,w) <= 127/255)
           gamma(h,w) = I(h,w) + 1/255;
       else
           gamma(h,w) = 256/255 - I(h,w);
       end
   end
end
end