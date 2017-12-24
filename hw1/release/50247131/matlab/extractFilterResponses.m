function [filterResponses] = extractFilterResponses(img, filterBank)
% Extract filter responses for the given image.
% Inputs:
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W x H x N*3 matrix of filter responses

%if the image is grayscale replicate it into 3 dimensions
if(size(img,3) == 1)
    img = repmat(img,[1 1 3]);
end

img = RGB2Lab(img);

filterResponses = [];
for i = 1:length(filterBank)
    filterResponses{3*i-2} = imfilter(img(:,:,3), filterBank{i});
    filterResponses{3*i-1} = imfilter(img(:,:,2), filterBank{i});
    filterResponses{3*i} = imfilter(img(:,:,1), filterBank{i});
end
% TODO Implement your code here


end
