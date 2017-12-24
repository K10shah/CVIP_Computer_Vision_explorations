function blobDetect = blobDetect(imgpath, k,  numLevels, threshold)

%reading the image from path given by the user
img = imread(imgpath);

%converting the image into grayscale
img = rgb2gray(img);

%converting image into double
img = im2double(img);

%extracting image height and width for later purposes
imageheight = size(img, 1);
imagewidth = size(img, 2);

%calculating scales for each level
sigmas(1) = 2;
scales(1) = 2*ceil(2*sigmas(1)) + 1;
for i = 2:numLevels
    scales(i) = scales(i-1)*k;
    sigmas(i) = sigmas(i-1)*k;
    scales(i) = ceil(scales(i));
    if(mod(scales(i),2) ==0)
        scales(i) = scales(i) + 1;
    end
    
end

%constructing a scale space which we will fill with filter responses
scale_space = zeros(imageheight, imagewidth, numLevels);

tic;

%run this loop for each level
for i = 1:numLevels
    
    %applying specific filter created for the specific level
    filt{i} = fspecial('log',scales(i), sigmas(i));
    
    %storing the result in one of the scale levels
    scale_space(:,:,i) = imfilter(img, filt{i});
    
    %L1 normalizing and Squaring the scale space
    si_Squa = (sigmas(i)^2);
    scale_space(:,:,i) = scale_space(:,:,i)*si_Squa;
    scale_space(:,:,i) = scale_space(:,:,i).^2;
    
end

storeTime = toc;

for i = 1:numLevels
    %Applying 2D non maximum suppression
    fun = @(x) maxval(x(:));
    NonMaxsuppress(:,:,i) = nlfilter(scale_space(:,:,i), [5 5], fun);
end


NonMaxSuppress3D = NonMaxSuppresed3D(NonMaxsuppress, numLevels);

%Removing unwanted centres based on threshold decided by the user
markersForMatch  = NonMaxSuppress3D > threshold;
NonMaxSuppress3D = NonMaxSuppress3D.* markersForMatch;

radii = CalcRadii(NonMaxSuppress3D,numLevels, k);


%reducing the radii numbers, eliminating neighboring radii for avoiding
%overlap
reducedRadii = reducedRadiiCal(radii);
reducedRadii = reducedRadiiCal(reducedRadii);

%displaying circles
show_all_circles(img, reducedRadii(:,1), reducedRadii(:,2 ), reducedRadii(:,3));
end