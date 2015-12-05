filename = 'clip1.mp4';

 videoFileReader = vision.VideoFileReader(filename);
 videoFrame      = step(videoFileReader);
 image1 = videoFrame;
%klt_face_detection(filename);

[feat1, descr1, face1, x_offset1, y_offset1] = vl_feat_detection(image1);

%image2 = imread('chadsmith-1.jpg');
image2 = imread('willferrell-2.jpg');
[feat2, descr2, face2, x_offset2, y_offset2] = vl_feat_detection(image2);

threshold = 1.8;
[matches,scores] = vl_ubcmatch(descr1, descr2, threshold);

% Get coordinates of the matched points
mp1 = feat1(1:2, matches(1,:))';
mp2 = feat2(1:2, matches(2,:))';

% Offset features by bbox location
mp1(:,1) = mp1(:,1) - x_offset1;
mp1(:,2) = mp1(:,2) - y_offset1;
mp2(:,1) = mp2(:,1) - x_offset2;
mp2(:,2) = mp2(:,2) - y_offset2;

figure('name','MATCHES AFTER RANSAC'); ax = axes;
showMatchedFeatures(face1,face2,mp1,mp2, 'montage','PlotOptions',{'bo','bo','g-'});
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');
