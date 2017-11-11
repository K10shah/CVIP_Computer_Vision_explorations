clear all
close all

I1 = histeq(imread('house1.jpg'));
I2 = histeq(imread('house2.jpg'));

img1gray = im2double(rgb2gray(I1));
img2gray = im2double(rgb2gray(I2));

%applying harris detector for finding corners
[cim1, r1, c1] = harris(img1gray, 2, 0.1, 2, 1);
[cim2, r2, c2] = harris(img2gray, 2, 0.1, 2, 1);

%calculating rows and cols for later use
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

%first 100 putative matches
for j = 1:100
    [row, col] = find(distances == min(distances(:)));
    feadesc1(j, :) = points1(row(1), :);
    feadesc2(j, :) = points2(col(1), :);
    distances(row, col) = 1000;
end

threshold =  0.0001;
no_of_inliers = 0;
AMat = [];
BestF = [];
Bestdistarray = [];
feadesc1(:,3) = 1;
feadesc2(:,3) = 1;
BestSample = [];


for N=1:1000
    
    count = 0;
    samples = randi(100,1,8);
    for k=1:8
        matches(k,1) = feadesc1(samples(k),2);
        matches(k,2) = feadesc1(samples(k),1);
        matches(k,3) = feadesc1(samples(k),2);
        matches(k,4) = feadesc1(samples(k),1);
        
    end
    
    F = fit_fundamental(matches, true);
    
    for i=1:size(feadesc1,1)
        distarray(i,:) = (feadesc2(i,:)*F*feadesc1(i,:)')^2;
        if(distarray(i,:) < threshold)
            count = count + 1;
        end
    end
    
    if(count > no_of_inliers)
        BestF = F;
        no_of_inliers = count;
        Bestdistarray = distarray;
        BestSample = samples;
    end
end

inliers = find(Bestdistarray < threshold);
feadesc1 = feadesc1(inliers, :);
feadesc2 = feadesc2(inliers, :);

L = (BestF * feadesc1')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* feadesc2,2);
closest_pt = feadesc2(:,1:2) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
clf;
imshow(img2gray); hold on;
plot(feadesc2(:,1), feadesc2(:,2), '+r');
line([feadesc2(:,1) closest_pt(:,1)]', [feadesc2(:,2) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');


figure;
imshow([img1gray img2gray]); hold on;
plot(feadesc1(:,1), feadesc1(:,2), '+r');
plot(feadesc2(:,1)+size(img1gray,2), feadesc2(:,2), '+r');
line([feadesc1(:,1) feadesc2(:,1) + size(img1gray,2)]', [feadesc1(:,2) feadesc2(:,2)]', 'Color', 'r');