function [ featurePoints ] = features_to_points( features, offsetX, offsetY )
% FEATURES TO POINTS 
%   Takes features struct and converts to an (nx2) vector of (x,y) points

featurePoints = [
    features.eyePair.x, features.eyePair.y;
    features.leftEye.x, features.leftEye.y;
    features.rightEye.x, features.rightEye.y;
    features.nose.x, features.nose.y;
    features.mouth.x, features.mouth.y ];

featurePoints = double(featurePoints);
featurePoints(:,1) = featurePoints(:,1) + offsetX;
featurePoints(:,2) = featurePoints(:,2) + offsetY;

end

