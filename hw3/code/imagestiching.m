clear all
close all
clc;
img1 = im2double(imread('..\data\part1\pier\1.jpg'));
img2 = im2double(imread('..\data\part1\pier\2.jpg'));

%converting to grayscale
img1gray = rgb2gray(img1);
img2gray = rgb2gray(img2);

%applying harris detector for finding corners
[cim1, r1, c1] = harris(img1gray, 2, 0.05, 2, 1);
[cim2, r2, c2] = harris(img2gray, 2, 0.05, 2, 1);

%calculating rows and cols for later use
img1rows = size(img1gray, 1);
img1cols = size(img1gray, 2);
img2rows = size(img2gray, 1);
img2cols = size(img2gray, 2);


%extracting initial descriptors
[im1desc, points1] = descriptormaker(img1gray, r1, c1);
[im2desc, points2] = descriptormaker(img2gray, r2, c2);

%calculating distances between each pair of descritors
distances = dist2(im1desc, im2desc);


feadesc1 = [];
feadesc2 = [];

total_putative = 150;

%first 150 putative matches
for j = 1:total_putative
    [row, col] = find(distances == min(distances(:)));
    feadesc1(j, :) = points1(row(1), :);
    feadesc2(j, :) = points2(col(1), :);
    distances(row, col) = 1000;
end


%Ransac implementation

threshold =  1;
no_of_inliers = 0;

AMat = [];
BestH = [];
Bestdistarray = [];
feadesc1(:,3) = 1;
feadesc2(:,3) = 1;
BestSample = [];

for N = 1:10000
    samples = randi(total_putative, 1, 4);
    for k = 1:4
        row1 = 2*k - 1;
        row2 = 2*k;
        x = feadesc1(samples(k), 1);
        y = feadesc1(samples(k), 2);
        xp = feadesc2(samples(k), 1);
        yp = feadesc2(samples(k), 2);
        
        AMat(row1, :) = [x, y, 1, 0, 0, 0, -x*xp, -y*xp, -xp];
        AMat(row2, :) = [0, 0, 0, x, y, 1, -x*yp, -y*yp, -yp];
    end
    
    [U,S,V]=svd(AMat);
    H = (reshape(V(:,end), [3,3]))';
    
    %H = H/H(3,3);
    
    newpoints = H * feadesc1';
    newpoints = newpoints';
    
    for i=1:size(newpoints,1)
        newpoints(i,1) = newpoints(i,1)/newpoints(i,3);
        newpoints(i,2) = newpoints(i,2)/newpoints(i,3);
    end
    
    distarray(:,1) = sqrt((newpoints(:,1) - feadesc2(:,1)).^2)  + ((newpoints(:,2) - feadesc2(:,2)).^2);
    
    temp = size(find(distarray < threshold),1);
    if(temp > no_of_inliers)
        BestH = H;
        no_of_inliers = temp;
        Bestdistarray = distarray;
        BestSample = samples;
    end
    
end

inputCorners = [];
inputCorners(1,:) = [1, 1];
inputCorners(2,:) = [1 , img1rows];
inputCorners(3,:) = [img1cols, 1];
inputCorners(4,:) = [img1cols, img1rows];
inputCorners(:,3) = 1;

outputCorners = BestH * inputCorners';
outputCorners = outputCorners';

for i=1:size(outputCorners,1)
    outputCorners(i,1) = outputCorners(i,1)/outputCorners(i,3);
    outputCorners(i,2) = outputCorners(i,2)/outputCorners(i,3);
end


T = maketform('projective', inputCorners(:,1:2), outputCorners(:,1:2));
[img1 xdata ydata] = imtransform(img1, T);


xlower = ceil(xdata(1,1));
if(xlower < 1)
    img2canvas = zeros(img2rows, img2cols - xlower,3);
    
    for i = 1:img2rows
        for j = 1:img2cols
            img2canvas(i, j - xlower,:) = img2(i, j,:);
        end
    end
    
    img2 = img2canvas;
    img2cols = size(img2, 2);
    
elseif(xlower > 1)
    
    img1canvas = zeros(img1rows, img1cols + xlower, 3);
    
    for i = 1:img1rows
        for j = 1:img1cols
            img1canvas(i, j + xlower,:) = img1(i, j,:);
        end
    end
    
    img1 = img1canvas;
    img1cols = size(img1, 2);
    
end



ylower = ceil(ydata(1,1));
if(ylower < 1)
    img2canvas = zeros(img2rows - ylower, img2cols, 3);
    
    for i = 1:img2rows
        for j = 1:img2cols
            img2canvas(i  - ylower, j,:) = img2(i, j,:);
            
        end
    end
    
    img2 = img2canvas;
    img2rows = size(img2, 1);
    
elseif(ylower > 1)
    
    img1canvas = zeros(img1rows + ylower, img1cols, 3);
    
    for i = 1:img1rows
        for j = 1:img1cols
            img1canvas(i  + ylower , j, :) = img1(i, j, :);
        end
    end
    
    img1 = img1canvas;
    img1rows = size(img1, 1);
end
 
img1rows = size(img1, 1);
img1cols = size(img1, 2);
img2rows = size(img2, 1);
img2cols = size(img2, 2);

rowdiff = img1rows - img2rows;
coldiff = img1cols - img2cols;

if(rowdiff > 0)
    img2(img2rows + 1:img2rows + rowdiff, :,:) = 0;
    img2rows = img2rows + rowdiff;
elseif(rowdiff < 0)
    img1(img1rows + 1:img1rows - rowdiff, :, :) = 0;
    img1rows = img1rows - rowdiff;
end

if(coldiff > 0)
    img2(:, img2cols + 1:img2cols + coldiff, :) = 0;
    img2cols = img2cols + coldiff;
elseif(coldiff < 0)
    img1(:, img1cols + 1:img1cols - coldiff, :) = 0;
    img2cols = img2cols - coldiff;
end

%creating final space which will include both images
finalcanvas = zeros(img1rows, img1cols,3);
overlap = zeros(img1rows, img1cols,3);;
finalcanvas = img1 + img2;
overlap = img1 & img2;

%averaging values of overlapping pixels
finalcanvas(overlap) = finalcanvas(overlap)/2;


figure;
imshow(finalcanvas);
imwrite(finalcanvas, '4.jpg');