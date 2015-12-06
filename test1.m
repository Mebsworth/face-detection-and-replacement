
% Read in image
filename = 'img/clip1.mp4';
videoFileReader = vision.VideoFileReader(filename);
videoFrame      = step(videoFileReader);
imageA = videoFrame;

imageB = imread('img/me1.png');

%% Detect faces
% Create a FACE cascade detector object.
faceDetectorA = vision.CascadeObjectDetector();
% Get bounding boxes of faces
bboxesA = step(faceDetectorA, imageA);    
% Let user choose which face to replace
[bboxA, faceA] = let_user_choose_feature(imageA, bboxesA);

% Create a FACE cascade detector object.
faceDetectorB = vision.CascadeObjectDetector();
% Get bounding boxes of faces
bboxesB = step(faceDetectorB, imageB);    
% Let user choose which face to replace
[bboxB, faceB] = let_user_choose_feature(imageB, bboxesB);

%% Detect facial features
[featuresA] = get_facial_features(imageA, faceA, bboxA);
[featuresB] = get_facial_features(imageB, faceB, bboxB);

%% Prepare features for TPS warp
x1 = bboxA(1);
y1 = bboxA(2);
x2 = bboxA(1) + bboxA(3);
y2 = bboxA(2) + bboxA(4);
featuresA = [featuresA; [x1+1, y1+1]; [x1+1, y2]; [x2, y1+1]; [x2 y2]];
x1 = bboxB(1);
y1 = bboxB(2);
x2 = bboxB(1) + bboxB(3);
y2 = bboxB(2) + bboxB(4);
featuresB = [featuresB; [x1+1, y1+1]; [x1+1, y2]; [x2, y1+1]; [x2 y2]];

featuresA(:,1) = featuresA(:,1) - bboxA(1);
featuresA(:,2) = featuresA(:,2) - bboxA(2);
featuresB(:,1) = featuresB(:,1) - bboxB(1);
featuresB(:,2) = featuresB(:,2) - bboxB(2);

%% TPS Warp
load('map.mat');
interp.method = 'invdist'; %'nearest'; %'none' % interpolation method
interp.radius = 5; % radius or median filter dimension
interp.power = 2; %power for inverse wwighting interpolation method
imgIn = faceB;
imgOut = faceA;
Xp = featuresB(:,1)';
Yp = featuresB(:,2)';
Xs = featuresA(:,1)';
Ys = featuresA(:,2)';
[imgW, imgWr]  = tps_warp(imgIn,[size(imgOut,2) size(imgOut,1)],[Xp' Yp'],[Xs' Ys'],interp); % thin plate spline warping
imgW = uint8(imgW);
imgWr = uint8(imgWr);

% figure;imshow(imgW,[]);

standardFace = imread('img/me3.png');
standardFaceBox = [1 1 285 379];
[featuresC] = get_facial_features(standardFace,standardFace,standardFaceBox);
featuresC = [featuresC; 1 1; 1 379; 285 1; 285 379]; 
mask = imread('img/me-mask2.png');
figure('name', 'raw mask'); imshow(mask);
Xp = featuresC(:,1)';
Yp = featuresC(:,2)';
Xs = featuresA(:,1)';
Ys = featuresA(:,2)';
[maskW, maskWr]  = tps_warp(mask,[size(face1,1) size(face1,2)],[Xp' Yp'],[Xs' Ys'],interp); % thin plate spline warping
maskW = uint8(maskW);
maskWr = uint8(maskWr);
unique(maskW)
maskW(maskW>0) = 1;
unique(maskW)
figure('name','warped mask'); imshow(maskW);

imgW = imgW .* maskW;
figure('name','masked'); imshow(im2double(imgW));

C = imfuse(im2double(imgW),faceA,'blend','Scaling','joint');
figure;imshow(C);hold on;
plot(featuresA(:,1), featuresA(:,2),'r.','MarkerSize',20);
%plot(featuresB(:,1), featuresB(:,2),'b.','MarkerSize',20);

%image1(bbox1(2):(bbox1(2) + bbox1(4)), bbox1(1):(bbox1(1) + bbox1(3)), :) = im2double(imgW);
%figure;imshow(image1,[]); colormap(map);

%% Display
% figure;
% 
% subplot(1,3,1); imshow(imgIn,[]);
% for ix = 1 : length(Xp),
% 	impoint(gca,Yp(ix),Xp(ix));
% end
% colormap(map);
% subplot(1,3,2); imshow(imgWr,[]);
% for ix = 1 : length(Xs),
% 	impoint(gca,Ys(ix),Xs(ix));
% end
% colormap(map);
% subplot(1,3,3); imshow(imgW,[]);
% for ix = 1 : length(Xs),
% 	impoint(gca,Ys(ix),Xs(ix));
% end
% colormap(map);

release(videoFileReader);


