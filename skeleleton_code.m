% Load in images

imnames = {'flowers/IMG_1.JPG','flowers/IMG_2.JPG', 'flowers/IMG_3.JPG'};

for i = 1:length(imnames),
  ims{i} = imread(imnames{i});
end

% Assume ims{1} is the central(base) image
base   = ims{1};
baseg  = imresize(rgb2gray(im2single(base)),.25);

for img = 2:length(imnames)
    input  = ims{img};
    inputg = imresize(rgb2gray(im2single(input)),.25);

    [input_points, base_points] = cpselect(inputg, baseg, 'Wait', true);
%     %preselected points
%     base_points = [302.2584   73.6877
%       357.0553   44.4126
%       479.4100  224.5668
%       542.4640  212.5566];
%     %
%     input_points = [304.6250  387.7500
%       360.1250  357.0000
%       480.8750  540.0000
%       541.6250  526.5000];
    
%     if(img > 2)
%          %[input_points, base_points] = cpselect(inputg, baseg, 'Wait', true);
%          input_points = [345.1250   33.7500
%           444.8750   36.7500
%           256.6250  214.5000
%           576.8750  168.7500];
% 
%          base_points = [360   541
%            455   541
%            267   720
%            591   665];
%     end

    x1 = base_points(:,1);
    y1 = base_points(:,2);
    x2 = input_points(:,1);
    y2 = input_points(:,2);

    % Compute homography that warps points from 'baseg' to 'inputg'
    H    = computeHomography(x1,y1,x2,y2);
    invH = inv(H);

    % In the following description, 'warping' may require computing a homography or inverse-homography

    % Compute the size of the final mosaic by warping the corner points of 'inputg'
    % onto 'baseg' coordinates and finding the max and min pixel coordinates
    % Compute all the coordinate in the final mosaic with meshgrid.m
    bc = [1 1; size(baseg,2) 1; 1 size(baseg,1); size(baseg,2) size(baseg,1)];
    corners = [1 1; size(inputg,2) 1; 1 size(inputg,1); size(inputg,2) size(inputg,1)];
    [cx, cy] = applyHomography(invH, corners(:,1), corners(:,2));

    %find max and min
    xcorn = [cx' bc(:,1)'];
    ycorn = [cy' bc(:,2)'];
    maxX = max(xcorn);
    maxY = max(ycorn);
    minX = min(xcorn);
    minY = min(ycorn);

    newCorners = [minX minY; minX maxY; maxX minY; maxX maxY];
    x = round(minX):round(maxX);
    y = round(minY):round(maxY);
    % For each coordinate in the final mosaic
    % 1. Compute its warped position in 'baseg' and 'inputg'. 
    % The warped position in 'baseg' should be simple to compute.
    [tx, ty] = meshgrid(x,y);
    
    %grab all colors for the base
    temp = interp2(baseg, tx, ty, 'linear');
    
    %apply H over the grid
    xx = [];
    yy = [];
    for i = 1:size(tx,2)
        [hx, hy] = applyHomography(H, tx(:,i), ty(:,i));
        xx = horzcat(xx, hx);
        yy = horzcat(yy, hy);
    end
    %grab all colors for the input
    temp2 = interp2(inputg, xx, yy,'linear');

    % 2. Determine its pixel color from the warped positon using interp.m. 
    % Some of these values may not be valid if they fall outside 'baseg' or 
    % 'inputg'. If the coordinate is valid in both images, you may select 
    % either value to display in the final image.

    %creating mask of where there is a value
    mask1 = ~isnan(temp);
    mask2 = ~isnan(temp2);

    %set the NaN's to 0
    temp(isnan(temp)) = 0;
    temp2(isnan(temp2)) = 0;

    %multiplying so that it doesnt overlap 
    almost = temp;
    there = xor(mask1,mask2).*temp2;

    result = almost+there;
    baseg = result;
end

imshow(result);
