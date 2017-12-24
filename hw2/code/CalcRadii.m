function radii = CalcRadii(NonMaxSuppress3D,numLevels, k)

radii = [];

%finding non zero values from the scale space and noting there x,y
%coordinates
for iter = 1:numLevels
    [rows, cols] = find(NonMaxSuppress3D(:,:,iter));
    
    tempRadii = [cols'; rows'];
    tempRadii(3,:) = sqrt(2) * 2*k^(iter - 1);
    
    radii = [radii; tempRadii'];
end

end