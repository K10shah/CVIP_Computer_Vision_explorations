function [wordMap] = getVisualWords(img, filterBank, dictionary)
% Compute visual words mapping for the given image using the dictionary of visual words.

% Inputs:
% 	img: Input RGB image of dimension (h, w, 3)
% 	filterBank: a cell array of N filters
% Output:
%   wordMap: WordMap matrix of same size as the input image (h, w)

% TODO Implement your code here
clc;

filterResponse = extractFilterResponses(img, filterBank);


for i=1:size(img,1)
    for j=1: size(img,2)
        
        for k=1:3*length(filterBank)
            points(k) = filterResponse{1,k}(i,j);
        end
        
        dist = pdist2(points, dictionary);
        
        [~, word] = find(dist == min(dist(:)));
        
        wordmap(i,j) = word;
        
    end
end

wordMap = wordmap;

end
