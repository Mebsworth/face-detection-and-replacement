function [featureRow, featureCol] = get_single_feature(face, featureName, bound)
% Finds center coordinates of feature (defined by 'featureName') in a face

detector = vision.CascadeObjectDetector('ClassificationModel', featureName, 'MergeThreshold', 0);
boxes = step(detector,face);

% DECISION: do this on face image or whole image? face image faster?
[nr,nc,~] = size(face);
featProbs = zeros(nr,nc);
[numBoxes, ~] = size(boxes);

%% Method #1: find point with max box score
for i = 1:numBoxes
    c1 = boxes(i,1);
    r1 = boxes(i,2);
    c2 = c1 + boxes(i,3) - 1;
    r2 = r1 + boxes(i,4) - 1;
    featProbs(r1:r2, c1:c2) = featProbs(r1:r2, c1:c2) + 1;
end

% Only look at points that are in the correct relative location 
if strcmp(featureName, 'LeftEye')
    featProbs(:,bound:nc) = 0;
elseif strcmp(featureName, 'RightEye')
    featProbs(:,1:bound) = 0;
elseif strcmp(featureName, 'Mouth')
    featProbs(1:bound,:) = 0;
elseif strcmp(featureName, 'Nose')
    featProbs(1:bound,:) = 0;
end

% Find point with maximum number of boxes containing it
[m, rows] = max(featProbs);
[m, col] = max(m);
maxPtX = col;
maxPtY = rows(col);

%% Step 2: Calculate Average Center of Relevant Bounding Boxes
% Only keep boxes that contain the pointX and pointY found in previous part
boxes = boxes(boxes(:,1) <= maxPtX, :);
boxes = boxes(boxes(:,2) <= maxPtY, :);
boxes = boxes( (boxes(:,1) + boxes(:,3)) >= maxPtX, :);
boxes = boxes( (boxes(:,2) + boxes(:,4)) >= maxPtY, :);

% Pull out centers of each box
X = boxes(:,1) + (boxes(:,3) / 2.0);
Y = boxes(:,2) + (boxes(:,4) / 2.0);

% Average the X and Y coordinates
[numBoxes, ~] = size(boxes);
featureRow = sum(Y) / numBoxes;
featureCol = sum(X) / numBoxes;


%% SHOW
% faceWithAllBoxes = insertShape(face,'Rectangle',boxes);
% figure; title(featureName); subplot(1,3,1); imshow(faceWithAllBoxes);

% faceWithRelevantBoxes = insertShape(face,'Rectangle',boxes);
% subplot(1,3,2); imshow(faceWithRelevantBoxes);
% 
% faceWithFeaturePoint = insertShape(face,'Circle',[featureCol, featureRow, 5]);
% subplot(1,3,3); imshow(faceWithFeaturePoint);

end
