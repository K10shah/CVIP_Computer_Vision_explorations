function [ warp_im ] = warpA( im, A, out_size )
% warp_im=warpAbilinear(im, A, out_size)
% Warps (w,h,1) image im using affine (3,3) matrix A 
% producing (out_size(1),out_size(2)) output image warp_im
% with warped  = A*input, warped spanning 1..out_size
% Uses nearest neighbor mapping.
% INPUTS:
%   im : input image
%   A : transformation matrix 
%   out_size : size the output image should be
% OUTPUTS:
%   warp_im : result of warping im by A


row = out_size(1);
col = out_size(2);


%Initializing the output image
output_Image = zeros(row, col);

InvA = inv(A);

for i=1:1:row
    for j=1:1:col
        
        p = InvA*[j;i;1];
        
        rounded_p1 = round(p(1));
        rounded_p2 = round(p(2));
        
        if(rounded_p1 > 0 && rounded_p2 > 0 && rounded_p1 < col && rounded_p2 < row)
            output_Image(i,j) = im(round(p(2)), round(p(1)));
        end
    end
end

warp_im = output_Image;
end