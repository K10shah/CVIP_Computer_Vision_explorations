function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.

filterBank  = createFilterBank();

% TODO Implement your code here

totalResponses = 3*length(filterBank());


%this loop runs until it has collected responses from all the images
%in the training set
for i=1:length(imPaths)
    
    %reading the image from the path given in the training set
    img = imread(imPaths{i,1});
    
    filterResponses = extractFilterResponses(img, filterBank);
    
    for j=1:totalResponses
        
        K = 200;
        thisResponse = filterResponses{1,j};
        
        %determining the height and width of the image (just a change of
        %wording :p
        lentgh = size(thisResponse,1);
        bredth = size(thisResponse,2);
        
        if(lentgh < K)
            alphaRows = randi(lentgh, K);
        else
            alphaRows = randperm(lentgh, K);
        end
        if(bredth < K)
            alphaCols = randi(bredth, K);
        else
            alphaCols = randperm(bredth, K);
        end
        
        thisCount = K*(i-1);
        for k=1:K
            finalResponses(thisCount + k,j) = thisResponse(alphaRows(k),alphaCols(k));
        end
    end
end
[~, dictionary] = kmeans(finalResponses, K, 'EmptyAction','drop');
end
