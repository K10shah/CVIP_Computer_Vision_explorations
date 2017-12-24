clear all
clc;

load('../data/traintest.mat');

imageMat = strrep(train_imagenames, 'jpg','mat');


imgb = load(strcat('../data/',imageMat{1}));
img(1) = load(strcat('../data/',imageMat{2}));
img(2) = imgb;
f = randi([10 100],500, 375);
img(2).wordMap = imgb.wordMap(:,:);
img(3) = load(strcat('../data/',imageMat{2}));

histb = getImageFeaturesSPM(2, imgb.wordMap, 150);

hist(:, 1) = getImageFeaturesSPM(2, img(1).wordMap, 150);
hist(:, 2) = getImageFeaturesSPM(2, img(2).wordMap, 150);
hist(:, 3) = getImageFeaturesSPM(2, img(3).wordMap, 150);

ans  = bsxfun(@min, histb, hist);

ans = sum(ans);

ans = [ans, 1];
abeymax = find(ans == max(ans(:)));