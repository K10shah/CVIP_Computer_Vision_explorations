function [final_Result] = alignChannels(red, green, blue)
% alignChannels - Given 3 images corresponding to different channels of a
%       color image, compute the best aligned result with minimum
%       aberrations
% Args:
%   red, green, blue - each is a matrix with H rows x W columns
%       corresponding to an H x W image
% Returns:
%   rgb_output - H x W x 3 color image output, aligned as desired

%% My code here

%Keeping the green channel as base channel.

%Aligning the red channel
red_Aligned = shiftAlign(red.red, green.green);

%Aligning the blue channel
blue_Aligned = shiftAlign(blue.blue, green.green);

%finally combining all the 3 channels after alignment is done
final_Result = cat(3,red_Aligned, green.green, blue_Aligned);

end

