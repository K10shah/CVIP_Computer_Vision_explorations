function aligned = shiftAlign(moving , stationary)
% alignChannels - Given 2 images corresponding to different channels of a
%       color image one considered to be stationary and the other to be
%       aligned corresponding to the stationary image
% Args:
%   moving, stationary - each is a matrix with H rows x W columns
%       corresponding to an H x W image
% Returns:
%   rgb_output - the aligned version of the moving image.

diff = [];

for i=-30:1:30
    for j=-30:1:30
        %applying circshift at different displacement positions and finding
        %the best one
        aligned = circshift(moving , [i,j]);
        diff = aligned - stationary;
        
        %calculating SSD for each combination of displacement over both the
        %axes
        SSD(i+31,j+31) = sum(sum(diff.^2));
    end
end

%extracting the minimum SSD value 
[value, I] = min(SSD(:));

%Finding row and column number of the minimum SSD value
[row, col] = ind2sub(size(SSD), I);

%adjusting with -31 since we had earlier added 31 to make the indices
%positive
aligned = circshift(moving , [row - 31,col - 31]);

end