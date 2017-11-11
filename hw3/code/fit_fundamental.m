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
    
    momentx = max(points1(:,1));
    momenty = max(points1(:,2));
    momentxp = max(points2(:,1));
    momentyp = max(points2(:,2));
    
    T_Mat = [1/momentx, 0, -mux/momentx; 0, 1/momenty, -muy/momenty; 0, 0, 1];
    T_Matp = [1/momentxp, 0, -muxp/momentxp; 0, 1/momentyp, -muyp/momentyp; 0, 0, 1];
    
    
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


end  %end function

