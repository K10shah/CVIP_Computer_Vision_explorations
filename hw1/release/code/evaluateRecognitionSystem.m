function [conf] = evaluateRecognitionSystem()
% Evaluates the recognition system for all test-images and returns the confusion matrix

load('vision.mat');
load('../data/traintest.mat');

% TODO Implement your code here

C = zeros(8);

dictionarySize = size(dictionary, 1);
filterBank = filterBank;
dictionary = dictionary;

train_features = train_features;
test_labels = test_labels;
train_labels = train_labels;

sizetest = size(test_imagenames ,1);

parfor i = 1:sizetest
    disp(i);
    image = imread(strcat('../data/',test_imagenames{i}));
    wordMap = getVisualWords(image, filterBank, dictionary);
    h = getImageFeaturesSPM(3, wordMap, dictionarySize);
    distances = distanceToSet(h, train_features);
    [~,nnI] = max(distances);
    
    a(i) = test_labels(i);
    b(i) = train_labels(nnI);
    %C(a,b) = C(a,b)+1; 
end



for i = 1:sizetest
        C(a(i),b(i)) = C(a(i),b(i)) + 1;
end

conf = trace(C)/sum(C(:));

save('confusion.mat','C');

plotconfusion(a,b);

end