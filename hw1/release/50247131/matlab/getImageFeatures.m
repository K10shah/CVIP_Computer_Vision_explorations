function [h] = getImageFeatures(wordMap, dictionarySize)
% Compute histogram of visual words
% Inputs:
% 	wordMap: WordMap matrix of size (h, w)
% 	dictionarySize: the number of visual words, dictionary size
% Output:
%   h: vector of histogram of visual words of size dictionarySize (l1-normalized, ie. sum(h(:)) == 1)

% TODO Implement your code here
%converting matrix into a vector
vert = wordMap(:);

%producing the histogram
h = hist(vert, 150);

%L1 normalizing the histogram
h = (h/sum(h));

h = h';

assert(numel(h) == dictionarySize);
end