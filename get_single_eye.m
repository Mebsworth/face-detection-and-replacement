function [featureRow, featureCol] = get_single_eye(face, faceBox, featureName, bound)
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
    c2 = c1 + boxes(i,3);
    r2 = r1 + boxes(i,4);
    
    featProbs(r1:r2, c1:c2) = featProbs(r1:r2, c1:c2) + 1;
end

if strcmp(featureName, 'LeftEye')
    featProbs(:,bound:nc) = 0;
elseif strcmp(featureName, 'RightEye')
    featProbs(:,1:bound) = 0;
elseif strcmp(featureName, 'Mouth')
    featProbs(1:bound,:) = 0;
elseif strcmp(featureName, 'Nose')
    featProbs(1:bound,:) = 0;
end

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

% Offset coordinates by face offset
featureRow = featureRow + faceBox(2);
featureCol = featureCol + faceBox(1);

end
