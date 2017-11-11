matches = load('house_matches.txt'); 
camera1 = load('house1_camera.txt');
camera2 = load('house2_camera.txt');

[u d v] = svd(camera1);
center1 = v(:,end);
center1(:) = center1(:)./center1(4);

[u d v] = svd(camera2);
center2 = v(:,end);
center2(:) = center2(:)./center2(4);

worldcoordinates = [];
for i=1:size(matches,1)
    x = matches(i,1);
    y = matches(i,2);
    xp = matches(i,3);
    yp = matches(i,4);
    
    A_Mat = [ y*camera1(3,:) - camera1(2,:);
                camera1(1,:) - x*camera1(3,:);
                yp*camera2(3,:) - camera2(2,:);
                camera2(1,:) - xp*camera2(3,:)];
   
    [U D V] = svd(A_Mat);
    worldcoordinates(i,:) = V(:,end);
    worldcoordinates(i,:) = worldcoordinates(i,:)./worldcoordinates(i,4);
end

figure; axis equal;
plot3(worldcoordinates(:,1), worldcoordinates(:,2), worldcoordinates(:,3),'.r');
grid on;
hold on;

plot3(center1(1), center1(2), center1(3),'*g');
plot3(center2(1), center2(2), center2(3),'*b');
