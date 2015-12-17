function [ features ] = points_to_features( featurePoints, offsetX, offsetY )
% Takes points and transforms back into features object 

featurePoints(:,1) = featurePoints(:,1) - offsetX;
featurePoints(:,2) = featurePoints(:,2) - offsetY;

features.eyePair.x = featurePoints(1,1);
features.eyePair.y = featurePoints(1,2);

features.leftEye.x = featurePoints(2,1);
features.leftEye.y = featurePoints(2,2);

features.rightEye.x = featurePoints(3,1);
features.rightEye.y = featurePoints(3,2);

features.nose.x = featurePoints(4,1);
features.nose.y = featurePoints(4,2);

features.mouth.x = featurePoints(5,1);
features.mouth.y = featurePoints(5,2);

end

