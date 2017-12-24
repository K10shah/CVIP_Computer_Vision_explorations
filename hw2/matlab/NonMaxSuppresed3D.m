function NonMaxSuppress3D = NonMaxSuppresed3D(NonMaxSupress2D, numLevels)

for i=1:numLevels
    
    if(i == 1)
        lower = i;
        upper = i + 1;
    else if(i == numLevels)
            lower = i - 1;
            upper = numLevels;
        else
            lower = i - 1;
            upper = i + 1;
        end
        
    end
    
    NonMaxSuppress3D(:, :, i) = max(NonMaxSupress2D(:,:,lower:upper), [] ,3);
end
markersForMatch = NonMaxSupress2D == NonMaxSuppress3D;
NonMaxSuppress3D = NonMaxSuppress3D .* markersForMatch;

end

