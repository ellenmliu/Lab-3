function T = tform(tri1,tri2)

%
% compute the transformation T which maps points
% of triangle1 to triangle2 
%
%
%  tri1 : 2x3 matrix containing coordinates of triangle 1
%  tri2 : 2x3 matrix containing coordinates of triangle 2
%
%  T : the resulting tranformation, should be a 3x3
%      matrix which works on points described in 
%      homogeneous coorindates 
%

%C = A^-1*B
A = [tri1; 1 1 1];
B = [tri2; 1 1 1];
T = B * inv(A);

% test code to make sure we have done the right thing
%

% apply mapping to corners of tri1 and 
% make sure the result is close to tri2
err1 = sum((T*[tri1(:,1);1] - [tri2(:,1);1]).^2);
assert(err1 < eps)

err2 = sum((T*[tri1(:,2);1] - [tri2(:,2);1]).^2);
assert(err2 < eps)

err3 = sum((T*[tri1(:,3);1] - [tri2(:,3);1]).^2);
assert(err3 < eps)

