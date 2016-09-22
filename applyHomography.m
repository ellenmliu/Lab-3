function [x2,y2] = applyHomography(H,x1,y1)

for i = 1:size(x1,1)
    A(i,:) = H * [x1(i) y1(i) 1]';
end
 x2 = A(:,1)./A(:,3);
 y2 = A(:,2)./A(:,3);