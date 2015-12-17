function [ bestMatch ] = find_best_replacement_face( faceA, featuresA, replacementFaces, rX, rY, rHulls, rFeatures )
% FIND BEST REPLACEMENT FACE 
%   Iterates through each possible face match
%   Finds homography needed to warp face match to face target
%   Compares all homographies and chooses face with the smallest difference
%   between original points and warped points

bestMatch.face = [];
bestMatch.x = [];
bestMatch.y = [];
bestMatch.convhull = [];
bestMatch.features = [];
minDiff = inf;

    %% Iterate through faces
    for i = 1:(size(replacementFaces,2))
        faceB = replacementFaces{i};
        Bx = rX{i};
        By = rY{i};
        convhullB = rHulls{i};
        featuresB = rFeatures{i};
        %% Homography
        % Set up params
        xDest = [ featuresA.eyePair.x, featuresA.leftEye.x, featuresA.rightEye.x, featuresA.nose.x,  featuresA.mouth.x];
        yDest = [ featuresA.eyePair.y, featuresA.leftEye.y, featuresA.rightEye.y, featuresA.nose.y, featuresA.mouth.y];
        xSource = [ featuresB.eyePair.x, featuresB.leftEye.x, featuresB.rightEye.x, featuresB.nose.x, featuresB.mouth.x];
        ySource = [ featuresB.eyePair.y, featuresB.leftEye.y, featuresB.rightEye.y, featuresB.nose.y, featuresB.mouth.y];
        % Find homography
        hMat = est_homography(xDest,yDest,xSource,ySource);
        [estimatedAx, estimatedAy] = apply_homography(hMat,Bx,By);
        % Find how much transformation is needed
        diff = sum(abs(Bx - estimatedAx)) + sum(abs(By - estimatedAy));
        if (diff <= minDiff)
            
            bestMatch.face = faceB;
            bestMatch.x = Bx;
            bestMatch.y = By;
            bestMatch.convhull = convhullB;
            bestMatch.features = featuresB;
            minDiff = diff;
        end
    end
end

