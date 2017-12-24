function blobDetectDownSample = blobDetectDownSamople(imgpath, k,  numLevels, threshold)

%reading the image from path given by the user
img = imread(imgpath);

%converting the image into grayscale
img = rgb2gray(img);

%converting image into double
img = im2double(img);

%extracting image height and width for later purposes
imageheight = size(img, 1);
imagewidth = size(img, 2);

%constructing a scale space which we will fill with filter responses
scale_space = zeros(imageheight, imagewidth, numLevels);

%creating the filter
filt = fspecial('log',5, 2);

tic;
%run this loop for each level
for i = 1:numLevels
    
    %calculating height and width of the downsampled image
    newimageheight = ceil(imageheight/(k^(i-1)));
    newimagewidth = ceil(imagewidth/(k^(i-1)));
    
    %downsampling
    downSample = imresize(img, [newimageheight newimagewidth]);
    
    %applying the Laplacian-of-gaussian filter to the downsampled image
    temp = imfilter(downSample, filt);
    
    
    %L1 normallizing and Squaring the scale space
    si_Squa = (2^2);
    temp = temp*si_Squa;
    temp = temp.^2;
    
    %upsampling the image to the size of the original image and storing it
    %in the scale space
    scale_space(:,:,i) = imresize(temp, [imageheight imagewidth]);
end
storeTime = toc;
for i = 1:numLevels
    %Applying 2D nonmaximum suppression
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