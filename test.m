 I1 = imresize(imread('me.jpg'),.75);
  I2 = imresize(imread('him.jpg'),.25);
  
  % get user clicks on keypoints
%   [pts_img1, pts_img2] = cpselect(I1, I2, 'wait', true);
pts_img1 = [236.0000  349.5000
  309.0000  360.5000
  406.0000  360.5000
  479.0000  344.5000
  308.0000  487.5000
  417.0000  484.5000
  177.0000  396.5000
  543.0000  401.5000
  393.0000  656.0000
  292.0000  547.0000
  453.0000  527.0000
  369.0000  502.0000
  367.0000  530.0000
  393.0000  613.0000
  453.0000  590.0000
  210.0000  300.0000
  319.0000  285.0000
  399.0000  284.0000
  508.0000  295.0000
  134.0000  175.0000
  556.0000  160.0000
  346.0000  124.0000
  344.0000    5.0000
  1         1
  1         size(I1,1)
  size(I1,2) 1
  size(I1,2) size(I1,1)];

pts_img2 = [198.7922  314.2497
  264.0162  303.0042
  347.9826  291.7587
  404.2102  291.0090
  262.5168  392.2186
  367.4749  380.9731
  165.8054  422.9563
  452.9407  392.9683
  309.3790  605.4901
  252.3321  458.3691
  382.1889  451.6136
  313.8827  394.1914
  315.3840  426.4679
  322.8901  510.5370
  381.4383  499.2778
  177.8006  293.2581
  287.2569  268.5180
  330.7395  262.5204
  428.2006  253.5240
  114.8257  141.0689
  464.1862  129.0737
  288.0066  133.5719
  288.7563   33.8617
  1         1
  1         size(I2,1)
  size(I2,2) 1
  size(I2,2) size(I2,1)];
  

  % generate triangulation 
  tri = delaunayTriangulation(pts_img1(:,1),pts_img1(:,2));
  t = 1;
pts_target = (1-t)*pts_img1 + t*pts_img2;
%warp

pts_source = pts_img1';
 pts_target = pts_target';
[h,w,d] = size(I1);
num_tri = size(tri,1);

[xx,yy] = meshgrid(1:w,1:h);
Xtarg = [xx(:) yy(:) ones(h*w,1)]';

T = zeros(3,3,num_tri); % tranformation matricies
for count = 1:num_tri
  T(:,:,count) = tform(pts_target(:,tri(count,:)), pts_source(:,tri(count,:)));
end

%tindex = mytsearch(pts_target(1,:), pts_target(2,:), tri, Xtarg(1,:,:),Xtarg(2,:,:));
tindex = pointLocation(tri, Xtarg(1,:,:)',Xtarg(2,:,:)')';
% now tranform target pixels back to 
% source image
Xsrc = zeros(size(Xtarg));
for t = 1:num_tri
    mask = [tindex == t;tindex == t;tindex == t];
    temp = T(:,:,t) * Xtarg;
% find source coordinates for all target pixels
% lying in triangle t
    Xsrc = Xsrc + mask.*temp;
end

R_target = interp2(I_source(:,:,1),Xsrc(1,:),Xsrc(2,:));
G_target = interp2(I_source(:,:,2),Xsrc(1,:),Xsrc(2,:));
B_target = interp2(I_source(:,:,3),Xsrc(1,:),Xsrc(2,:));