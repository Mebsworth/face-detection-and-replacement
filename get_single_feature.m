function [featureRow, featureCol] = get_single_feature(image, face, faceBox, featureName )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

%detector = vision.CascadeObjectDetector('ClassificationModel', featureName, 'MergeThreshold', 0, 'UseROI',1);
detector = vision.CascadeObjectDetector('ClassificationModel', featureName, 'MergeThreshold', 0);
%boxes = step(detector, image, faceBox);
boxes = step(detector,face);
imageWithBoxes1 = insertShape(face, 'Rectangle', boxes);

% DECISION: do this on face image or whole image? face image faster?
[nr,nc,~] = size(face);
featProbs = zeros(nr,nc);
[numBoxes, ~] = size(boxes);

%% Method #1: find point with max box score
for i = 1:numBoxes
    c1 = boxes(i,1);
    r1 = boxes(i,2);
    c2 = c1 + boxes(i,3);
    r2 = r1 + boxes(i,4);
    
    featProbs(r1:r2, c1:c2) = featProbs(r1:r2, c1:c2) + 1;
end

[m, rows] = max(featProbs);
[m, col] = max(m);
maxPtX = col;
maxPtY = rows(col);

%% Method #2: find average center
% Only keep boxes that contain the pointX and pointY found in previous part
boxes = boxes(boxes(:,1) <= maxPtX, :);
boxes = boxes(boxes(:,2) <= maxPtY, :);
boxes = boxes( (boxes(:,1) + boxes(:,3)) >= maxPtX, :);
boxes = boxes( (boxes(:,2) + boxes(:,4)) >= maxPtY, :);

imageWithBoxes2 = insertShape(face, 'Rectangle', boxes);

X = boxes(:,1) + (boxes(:,3) / 2.0);
Y = boxes(:,2) + (boxes(:,4) / 2.0);

[numBoxes, ~] = size(boxes);

featureRow = sum(Y) / numBoxes;
featureCol = sum(X) / numBoxes;

%% Show feature center on face
figure; imshow(imageWithBoxes1);
figure('name', 'relevant boxes'); imshow(imageWithBoxes2);
%face_dot(rows(col), col, :) = [0 0 255];
figure;imshow(face);hold on; 
plot(maxPtX, maxPtY, 'b.','MarkerSize',20); 
plot(featureCol, featureRow, 'r.','MarkerSize',20);

%% Show whole feature
% featProbs = featProbs / max(max(featProbs));
% figure;imshow(imageWithBoxes1);
% figure;imshow(featProbs);
% featProbs = repmat(featProbs, [1,1,3]);
% face2 = face .* featProbs;
% figure;imshow(face2);

% figure;imshow(imageWithBoxes2);
% figure;imshow(imageWithBoxes3);

end

