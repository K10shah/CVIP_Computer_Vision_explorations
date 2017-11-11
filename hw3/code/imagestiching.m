clear all
close all
clc;
img1 = im2double(imread('4.jpg'));
img2 = im2double(imread('..\data\part1\hill\3.jpg'));

img1gray = rgb2gray(img1);
img2gray = rgb2gray(img2);



%imshow(img1gray);
[cim1, r1, c1] = harris(img1gray, 2, 0.05, 2, 1);
[cim2, r2, c2] = harris(img2gray, 2, 0.05, 2, 1);

img1rows = size(img1gray, 1);
img1cols = size(img1gray, 2);
img2rows = size(img2gray, 1);
img2cols = size(img2gray, 2);

k = 1;
for i = 1:size(r1,1)
    if(r1(i) >= 5 && c1(i) >= 5 &&  r1(i) <= img1rows - 4 && c1(i) <= img1cols - 4)
        im1desc(k,:) = reshape(img1gray(r1(i)-4:r1(i)+4, c1(i)-4:c1(i)+4), [1,81]);
        points1(k,:) = [c1(i), r1(i)];
        k = k + 1;
    end
end

k = 1;
for i = 1:size(r2,1)
    if(r2(i) >= 5 && c2(i) >= 5 &&  r2(i) <= img2rows - 4 && c2(i) <= img2cols - 4)
        im2desc(k,:) = reshape(img2gray(r2(i)-4:r2(i)+4, c2(i)-4:c2(i)+4), [1,81]);
        points2(k,:) = [c2(i), r2(i)];
        k = k + 1;
    end
end


distances = dist2(im1desc, im2desc);

feadesc1 = [];
feadesc2 = [];
count = 0;

%first 150 putative matches
for j = 1:150
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

for N = 1:5000
    samples = randi(150, 1, 4);
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

% subplot(1,2,1), imagesc(img1), axis image, colormap(gray), hold on
% plot(feadesc1(BestSample(:), 1),feadesc1(BestSample(:), 2),'r.','MarkerSize',20);
% 
% subplot(1,2,2), imagesc(img2), axis image, colormap(gray), hold on
% plot(feadesc2(BestSample(:), 1),feadesc2(BestSample(:), 2),'r.','MarkerSize',20);

inputCorners = [];
inputCorners(1,:) = [1, 1];
inputCorners(2,:) = [1 , size(img1,1)];
inputCorners(3,:) = [size(img1,2), 1];
inputCorners(4,:) = [size(img1,2), size(img1,1)];
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

figure;
imshow(img1);

figure;
imshow(img2);
 
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


finalcanvas = zeros(img1rows, img1cols,3);
overlap = zeros(img1rows, img1cols,3);;
finalcanvas = img1 + img2;
overlap = img1 & img2;
finalcanvas(overlap) = finalcanvas(overlap)/2;
% for i =1:size(img1gray, 1)
%     for j=1:size(img1gray, 2)
%         if(img1gray(i,j) > 0 && img2gray(i,j) > 0)
%             finalcanvas(i,j) = (img1gray(i,j) + img2gray(i,j))/2;
%         else 
%             finalcanvas(i,j) = max(img1gray(i,j), img2gray(i,j));
%         end
%     end
% end

figure;
imshow(finalcanvas);
imwrite(finalcanvas, '4.jpg');