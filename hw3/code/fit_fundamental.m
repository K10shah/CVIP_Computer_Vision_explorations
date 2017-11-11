function [ F_Mat ] = fit_fundamental( matches, norm )
%FIT_FUNDAMENTAL Summary of this function goes here
%   Detailed explanation goes here
if( norm == false)
    F_Mat = [];
    
    A_Mat = [];
    
    for i = 1 : size(matches, 1)
        u = matches(i,1);
        
        up = matches(i,3);
        v = matches(i,2);
        vp = matches(i,4);
        
        A_Mat(i,:) = [up*u, up*v, up, vp*u, vp*v, vp, u, v, 1];
        
        %end for
    end
    
    [U, F_Mat, V] = svd(A_Mat);
    F_Mat = (reshape(V(:,end), [3,3]))';
    
    [U, DCE, V] = svd(F_Mat);
    
    [row, col] = find(DCE == min(diag(DCE)));
    
    DCE(row, col) = 0;
    
    F_Mat2 = U * DCE * V';
    
    F_Mat = F_Mat2;
    
else
    T_Mat = [];
    T_Matp = [];
    points1 = matches(:, 1:2);
    points1(:,3) = 1;
    
    points2 = matches(:, 3:4);
    points2(:,3) = 1;
    
    mux = mean(points1(:,1));
    muy = mean(points1(:,2));
    muxp = mean(points2(:,1));
    muyp = mean(points2(:,2));

    for i=1:size(points1,1)
        distances1(i) = sqrt((points1(i,1) - mux)^2 + (points1(i, 2) - muy)^2);
    end
    
    var1 = sum(distances1)/size(points1,1);
    
     for i=1:size(points1,1)
        distances2(i) = sqrt((points2(i,1) - muxp)^2 + (points2(i, 2) - muyp)^2);
     end
     
     varp = sum(distances2)/size(points1,1);
    
    T_Mat = [1/var1, 0, -mux/var1; 0, 1/var1, -muy/var1; 0, 0, 1];
    T_Matp = [1/varp, 0, -muxp/varp; 0, 1/varp, -muyp/varp; 0, 0, 1];
    
    
    points1 = (T_Mat * points1')';
    points2 = (T_Matp * points2')';
    
    A_Mat = [];
    
    for i = 1 : size(points1, 1)
        u = points1(i,1);
        up = points2(i,1);
        v = points1(i,2);
        vp = points2(i,2);
        
        A_Mat(i,:) = [up*u, up*v, up, vp*u, vp*v, vp, u, v, 1];
        
        %end for
    end
    
    [U, F_Mat, V] = svd(A_Mat);
    F_Mat = (reshape(V(:,end), [3,3]))';
    
    [U, DCE, V] = svd(F_Mat);
    
    [row, col] = find(DCE == min(diag(DCE)));
    
    DCE(row, col) = 0;
    
    F_Mat2 = U * DCE * V';
    
    F_Mat = T_Matp'*F_Mat2*T_Mat;
    
    
end  %end norm if else

points1 = matches(:, 1:2);
points1(:,3) = 1;

points2 = matches(:, 3:4);
points2(:,3) = 1;


AlgDist = 0;

for i = 1:size(points1,1)
    temp = points2(i,:) * F_Mat * points1(i,:)';
    temp = temp^2;
    AlgDist = AlgDist + temp;
end
AlgDist = AlgDist / size(points1,1);

lines1 = (F_Mat*points1')';
lines2 = (F_Mat'*points2')';

GeoDist = 0;
for i = 1:size(points1,1)
    a = lines1(i,1);
    b = lines1(i,2);
    c = lines1(i,3);
    ap = lines2(i,1);
    bp = lines2(i,2);
    cp = lines2(i,3);
    dist1 = (abs(ap*points1(i,1) + bp*points1(i,2) + cp))/sqrt(ap^2 + bp^2);
    dist2 = (abs(a*points2(i,1) + b*points2(i,2) + c))/sqrt(a^2 + b^2);
    
    GeoDist = GeoDist + (dist1^2 + dist2^2);
end

GeoDist = GeoDist/size(points1, 1);

str = sprintf('Dist 1 %f', AlgDist);
disp(str);
str = sprintf('Dist 2 %f', GeoDist);
disp(str);
end

