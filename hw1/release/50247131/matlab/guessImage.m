function guessedImage = guessImage( imagename ) 
% Given a path to a scene image, guess what scene it is
% Input:
%   imagename - path to the image

	fprintf('[Loading..]\n');
	load('vision.mat');
	load('../data/traintest.mat','mapping');

	image = im2double(imread(imagename));

    dictionarySize = size(dictionary,1);
	% imshow(image);
	fprintf('[Getting Visual Words..]\n');
	wordMap = getVisualWords(image, filterBank, dictionary);
	h = getImageFeaturesSPM(3, wordMap, dictionarySize);
	distances = distanceToSet(h, train_features);
	[~,nnI] = max(distances);
	guessedImage = mapping{train_labels(nnI)};
	fprintf('[My Guess]:%s.\n',guessedImage);

	figure(1);
	imshow(image);
	title('image to classify')

end
