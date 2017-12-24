function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

% TODO Implement your code here

layerNum = layerNum - 1;
rows = size(wordMap,1);
cols = size(wordMap,2);

finalHist = [];
for L = layerNum:-1:0
    temp = [];
    for i=1:2*L
        for j=1:2*L
            
            xchop1 = round((((i-1)*rows)/(2*L)) + 1);
            xchop2 = round(((i)*rows)/(2*L));
            
            ychop1 = round((((j-1)*cols)/(2*L)) + 1);
            ychop2 = round(((j)*cols)/(2*L));
            
            
            chop = wordMap(xchop1:xchop2, ychop1:ychop2);
            %producing the histogram
            
            vert = chop(:);
            h = hist(vert, dictionarySize);
            temp = [temp , h];
        end
    end
    
    if(L ==0)
        vert = wordMap(:);
        h = hist(vert, dictionarySize);
        temp = [temp, h];
    end
    
    if(L==1 || L == 0)
        weight = 1/(2^layerNum);
    else
        weight = 1/(2^(1 + layerNum - L));
    end
    
    ax = sum(temp);
    temp = temp * weight;
    
    finalHist = [finalHist , temp];
    
end


h = finalHist';
h = h/sum(h);

end