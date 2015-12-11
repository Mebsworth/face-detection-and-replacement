function [ warpedFace, warpedMask ] = warp_replacement_face( faceA, faceB, Bx, By, Ax, Ay, mask)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

disp('beginning warp_replacement_face');
% 
% figure;imshow(faceA);hold on; plot(Ax,Ay,'r.','MarkerSize',20);
% figure;imshow(faceB);hold on; plot(Bx,By,'r.','MarkerSize',20);


load('map.mat');
interp.method = 'nearest'; %'invdist','nearest'; %'none' % interpolation method
interp.radius = 5; % radius or median filter dimension
interp.power = 2; %power for inverse wwighting interpolation method

imgIn = faceB;
imgOut = faceA;

lim = size(faceA,2);

Xsource = Bx';
Ysource = By';
Xtarget = Ax';
Ytarget = Ay';

[warpedFace, ~]  = tps_warp(imgIn,[size(imgOut,2) size(imgOut,1)],[Xtarget' Ytarget'],[Xsource' Ysource'],interp); % thin plate spline warping
[warpedMask, ~, ~] = tps_warp(mask, [size(imgOut,2) size(imgOut,1)],[Xtarget' Ytarget'],[Xsource' Ysource'],interp);

warpedFace = uint8(warpedFace);

disp('ending warp_replacement_face');

end

