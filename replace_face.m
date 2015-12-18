function [ blendedFace ] = replace_face( faceA, featuresA, replacementFaces, rX, rY, rHulls, rFeatures )
% REPLACE FACE
% Given an imageA, replaces the face in image A with another face

% Find best replacement face
[ bestMatch ] = find_best_replacement_face(faceA, featuresA, replacementFaces, rX, rY, rHulls, rFeatures);
faceB = bestMatch.face;
faceB = imresize(faceB, [size(faceA,1),size(faceA,2)]);
[featuresB] = get_facial_features(faceB);
[Bx, By, convhullB, BxE, ByE, expandedHull] = get_convex_hull(featuresB, faceB);

% Create mask of replacement face
mask = poly2mask(Bx(convhullB),By(convhullB),size(faceB,2),size(faceB,1));
expandedMask = poly2mask(BxE(expandedHull), ByE(expandedHull),size(faceB,2), size(faceB,1));

% Set up points for warp
Afx = [ featuresA.eyePair.x, featuresA.leftEye.x, featuresA.rightEye.x, featuresA.nose.x, featuresA.mouth.x]';
Afy = [ featuresA.eyePair.y, featuresA.leftEye.y, featuresA.rightEye.y, featuresA.nose.y, featuresA.mouth.y]';
Bfx = [ featuresB.eyePair.x, featuresB.leftEye.x, featuresB.rightEye.x, featuresB.nose.x, featuresB.mouth.x]';
Bfy = [ featuresB.eyePair.y, featuresB.leftEye.y, featuresB.rightEye.y, featuresB.nose.y, featuresB.mouth.y]';

% Warp
[warpedFace, warpedMask, warpedExpandedMask] = warp_replacement_face(faceA, faceB, Bfx, Bfy, Afx, Afy, mask, expandedMask);

% Blend
blendedFace = blend_faces(im2double(faceA),im2double(warpedFace),warpedMask, warpedExpandedMask);

end

