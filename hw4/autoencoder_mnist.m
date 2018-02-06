clear all
clc;

%reading training images
trainImg = fopen('train-images.idx3-ubyte','r','b');
fseek(trainImg,16,'bof');
trainImages = zeros(784, 60000);

for i = 1:60000
    trainImages(:,i)= fread(trainImg, 784, 'uchar')/255;
end


%reading test images
testImg = fopen('t10k-images.idx3-ubyte','r','b');
fseek(testImg,16,'bof');
testImages = zeros(784, 10000);

for i = 1:10000
    testImages(:,i)= fread(testImg, 784, 'uchar')/255;%
end


%reading train labels
trainlbl = fopen('train-labels.idx1-ubyte','r','b'); % first we have to open the binary file
fseek(trainlbl,8,'bof');
trainLabels = zeros(10, 60000);
for i = 1:60000
    lbl = fread(trainlbl,1,'uchar');
    trainLabels(lbl + 1 ,i)  = 1 ;
end

%reading test labels
testlbl = fopen('t10k-labels.idx1-ubyte','r','b'); % first we have to open the binary file
fseek(testlbl,8,'bof');
testLabels = zeros(10, 10000);
for i = 1:10000
    lbl = fread(testlbl,1,'uchar');
    testLabels(lbl + 1 ,i)  = 1 ;
end

rng('default');


for i = 1:60000
    xTrainImages{1,i} = reshape(trainImages(:,i), [28,28])';
end

%size of first hidden layer
hiddenSize1 = 500;

%first autoencoder
autoenc1 = trainAutoencoder(xTrainImages,hiddenSize1, ...
    'MaxEpochs',200, ...
    'L2WeightRegularization',0.004, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.15, ...
    'ScaleData', false);

feat1 = encode(autoenc1,xTrainImages);

%second autoencoder

hiddenSize2 = 200;
autoenc2 = trainAutoencoder(feat1,hiddenSize2, ...
    'MaxEpochs',100, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.1, ...
    'ScaleData', false);

feat2 = encode(autoenc2, feat1);

hiddenSize3 = 50;
autoenc3 = trainAutoencoder(feat2, hiddenSize3, ...
    'MaxEpochs',100, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.1, ...
    'ScaleData', false);

feat3 = encode(autoenc3, feat2);

softnet = trainSoftmaxLayer(feat3,trainLabels,'MaxEpochs',400);

deepnet = stack(autoenc1,autoenc2, autoenc3, softnet);

% Get the number of pixels in each image
imageWidth = 28;
imageHeight = 28;
inputSize = imageWidth*imageHeight;

% Perform fine tuning
deepnet = train(deepnet,trainImages,trainLabels);

y = deepnet(testImages);
plotconfusion(testLabels,y);