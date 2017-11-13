function [ desc, points] = descriptormaker( img, r, c)
%DESCRIPTORMAKER :
%   This function taken the coordinates of keypoints of an image and extracts their
%   neighbourhoods and flattens them into vectors
%   Arguements: 
%        img - the image of which key points are detected
%        r - row values of the key points
%        c - column values of key points
%   
%   Returns:
%        desc - the flattened neighbourhoods of the keypoints
%        points - x,y coordinate in 2-D space of the keypoints


k = 1;
imgrows = size(img, 1);
imgcols = size(img, 2);
for i = 1:size(r,1)
    if(r(i) >= 5 && c(i) >= 5 &&  r(i) <= imgrows - 4 && c(i) <= imgcols - 4)
        desc(k,:) = reshape(img(r(i)-4:r(i)+4, c(i)-4:c(i)+4), [1,81]);
        points(k,:) = [c(i), r(i)];
        k = k + 1;
    end
end

end

