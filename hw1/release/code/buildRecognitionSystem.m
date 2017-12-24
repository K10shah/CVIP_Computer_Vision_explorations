function buildRecognitionSystem()
% Creates vision.mat. Generates training features for all of the training images.

	load('dictionary.mat');
	load('../data/traintest.mat');

	% TODO create train_features

    imageMat = strrep(train_imagenames, '.jpg','.mat');
    
    dictionarySize = size(dictionary , 1);
    for i=1:size(imageMat)
        disp(i);
        load(strcat('../data/',imageMat{i}))
        train_features(:,i) = getImageFeaturesSPM(3, wordMap, dictionarySize);
    end
     
	save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels');

end