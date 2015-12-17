function [ featurePoints ] = features_to_points( features, offsetX, offsetY )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

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

