function [ bestMatch ] = find_best_replacement_face2( faceA, featuresA, replacementFaces, rX, rY, rHulls, rFeatures)
% FIND BEST REPLACEMENT FACE 
%   Iterates through each possible face match
%   Finds homography needed to warp face match to face target
%   Compares all homographies and chooses face with the smallest difference
%   between original points and warped points

bestMatch.face = [];
bestMatch.X = [];
bestMatch.Y = [];
bestMatch.hull = [];
bestMatch.features = [];
minDiff = inf;

    %% Iterate through faces
    for i = 1:6
        imageFilePath = strcat('replacement_faces/face', num2str(i), '.jpg');
        if (exist(imageFilePath, 'file'))
            image = imread(imageFilePath);
            [faceB, bboxB] = detect_face(image);
            faceB = imresize(faceB, [size(faceA,1), size(faceA,2)]);
            % Detect facial features
            [featuresB] = get_facial_features(faceB);
            % Get convex hull
            [Bx,By,convhullB] = get_convex_hull(featuresB, faceB);
            
            %% Homography
            % Set up params
            xDest = [ featuresA.leftEye.x, featuresA.rightEye.x, featuresA.eyePair.x, featuresA.nose.x,  featuresA.mouth.x];
            yDest = [ featuresA.leftEye.y, featuresA.rightEye.y, featuresA.eyePair.y, featuresA.nose.y, featuresA.mouth.y];
            xSource = [ featuresB.leftEye.x, featuresB.rightEye.x, featuresB.eyePair.x, featuresB.nose.x, featuresB.mouth.x];
            ySource = [ featuresB.leftEye.y, featuresB.rightEye.y, featuresB.eyePair.y, featuresB.nose.y, featuresB.mouth.y];
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
                minDiff = diff;
            end
        else
            fprintf('File %s does not exist.\n', jpgFileName);
        end
    end
end

