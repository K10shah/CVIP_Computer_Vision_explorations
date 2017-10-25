% Problem 1: Image Alignment

clc;

%% 1. Load images (all 3 channels)
red = load("../data/red.mat");  % Red channel
green = load("../data/green.mat");  % Green channel
blue = load("../data/blue.mat");  % Blue channel

%% 2. Find best alignment
% Hint: Lookup the 'circshift' function

%Calling alignChannels function which will return the resulting image with
%all the 3 channels aligned
rgbResult = alignChannels(red, green, blue);

imshow(rgbResult);

%% 3. Save result to rgb_output.jpg (IN THE "results" folder)
imwrite(rgbResult, '../results/rgb_output.jpg');