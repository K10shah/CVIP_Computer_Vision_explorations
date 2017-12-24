function reducedRadii = reducedRadiiCal(radii)
if(size(radii,1) ~=0)
radii = sortrows(radii);


reducedRadii(1,:) = radii(1,:);
count = 1;
for i=2:size(radii, 1)
    if(abs(radii(i,1) - radii(i-1,1)) <=20)
        if(abs(radii(i,2) - radii(i -1, 2)) <=20)
            reducedRadii(count,:) = radii(i,:);
        else
            count  = count + 1;
            reducedRadii(count, :) = radii(i,:);
        end
    else
        count  = count + 1;
        reducedRadii(count, :) = radii(i,:);
    end
    
end

radii = sortrows(reducedRadii,2);


secondRadii(1,:) = radii(1,:);
count = 1;
for i=2:size(radii, 1)
    if(abs(radii(i,2) - radii(i-1,2)) <=20)
        if(abs(radii(i,1) - radii(i-1, 1)) <=20)
            secondRadii(count,:) = radii(i,:);
        else
            count  = count + 1;
            secondRadii(count, :) = radii(i,:);
        end
    else
        count  = count + 1;
        secondRadii(count, :) = radii(i,:);
    end
    
end

reducedRadii = secondRadii;
else
    reducedRadii = radii;
end
end

