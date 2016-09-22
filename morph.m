 %
  % morphing script
  %

  % load in two images...
  I1 = double(imresize(imread('me.jpg'),.75));
  I2 = double(imresize(imread('him.jpg'),[size(I1,1) size(I1,2)]));
  
  % get user clicks on keypoints
%   [pts_img1, pts_img2] = cpselect(I1, I2, 'wait', true);
%points are hardcoded
pts_img1 = [237.0000  347.5000
  310.0000  362.5000
  407.0000  360.5000
  480.0000  343.5000
  208.0000  295.5000
  318.0000  277.5000
  402.0000  276.5000
  501.0000  284.5000
  257.0000  260.5000
  475.0000  254.5000
  309.0000  488.5000
  417.0000  480.5000
  173.0000  346.0000
  554.0000  332.0000
  354.0000  130.0000
  139.0000  158.0000
  549.0000  144.0000
  355.0000    4.0000
  366.0000  505.0000
  291.0000  549.0000
  450.0000  527.0000
  368.0000  528.0000
  393.0000  654.0000
  389.0000  615.0000
  455.0000  590.0000
  248.0000  542.0000
  496.0000  537.0000
  1         1
  1         size(I1,1)
  size(I1,2) 1
  size(I1,2) size(I1,1)];

pts_img2 = [240.0000  341.5000
  312.0000  331.5000
  406.0000  321.5000
  483.0000  320.5000
  209.0000  308.5000
  326.0000  288.5000
  391.0000  279.5000
  501.0000  272.5000
  244.0000  274.5000
  468.0000  243.5000
  304.0000  426.5000
  434.0000  412.5000
  173.0000  362.5000
  527.0000  324.5000
  352.0000  152.0000
  131.0000  160.0000
  543.0000  148.0000
  341.0000   36.0000
  370.0000  429.0000
  296.0000  503.0000
  449.0000  493.0000
  374.0000  469.0000
  370.0000  664.0000
  381.0000  560.0000
  450.0000  549.0000
  231.0000  546.0000
  497.0000  547.0000
  1         1
  1         size(I2,1)
  size(I2,2) 1
  size(I2,2) size(I2,1)];
  

  % generate triangulation 
  tri = delaunayTriangulation(pts_img1(:,1),pts_img1(:,2));

  % now produce the frames of the morph sequenceA
  for fnum = 0:45
    t = fnum/45;
    pts_target = (1-t)*pts_img1 + t*pts_img2;                % intermediate key-point locations
    I1_warp = warp(I1,pts_img1,pts_target,tri);              % warp image 1
    I2_warp = warp(I2,pts_img2,pts_target,tri);              % warp image 2
    Iresult = (1-t)*I1_warp + t*I2_warp;                     % blend the two warped images
    imwrite(uint8(Iresult),sprintf('frames_%2.2d.jpg',fnum),'jpg')
  end