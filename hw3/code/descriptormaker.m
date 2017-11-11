function [ desc, points] = descriptormaker( img, r, c)
%DESCRIPTORMAKER Summary of this function goes here
%   Detailed explanation goes here
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

