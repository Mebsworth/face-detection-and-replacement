function [ warpedFace, warpedMask, warpedExpandedMask ] = warp_replacement_face( faceA, faceB, Bx, By, Ax, Ay, mask, expandedMask)
% WARP REPLACEMENT FACE 
 
% figure;imshow(faceA);hold on; plot(Ax,Ay,'r.','MarkerSize',20);
% figure;imshow(faceB);hold on; plot(Bx,By,'r.','MarkerSize',20);

load('map.mat');
interp.method = 'nearest'; %'invdist','nearest'; %'none' % interpolation method
interp.radius = 5; % radius or median filter dimension
interp.power = 2; %power for inverse wwighting interpolation method

imgIn = faceB;
imgOut = faceA;

Ax = double(Ax);
Ay = double(Ay);
% figure; subplot(1,2,1); imshow(faceB); hold on; plot(Bx, By, 'r.', 'MarkerSize', 20);
% subplot(1,2,2); imshow(faceA); hold on; plot(Ax, Ay, 'r.', 'MarkerSize', 20);

Xsource = By';
Ysource = Bx';
Xtarget = Ay';
Ytarget = Ax';

%% TPS WARP
[warpedFace, ~]  = tps_warp(imgIn,[size(imgOut,2) size(imgOut,1)],[Xtarget' Ytarget'],[Xsource' Ysource'],interp); % thin plate spline warping
[warpedMask, ~, ~] = tps_warp(mask, [size(imgOut,2) size(imgOut,1)],[Xtarget' Ytarget'],[Xsource' Ysource'],interp);
[warpedExpandedMask, ~,~] = tps_warp(expandedMask, [size(imgOut,2), size(imgOut,1)], [Xtarget' Ytarget'],[Xsource' Ysource'],interp);

warpedFace = uint8(warpedFace);

%disp('ending warp_replacement_face');

end

