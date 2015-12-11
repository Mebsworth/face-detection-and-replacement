function [ x,y,cHull ] = get_convex_hull( features, face )

disp('beginning get_convex_hull');

distEyesToNose = features.nose.y - features.eyePair.y;
distLeftEyeToCenter = features.eyePair.x - features.leftEye.x;
distRightEyeToCenter = features.rightEye.x - features.eyePair.x;
distMouthToNose = features.mouth.y - features.nose.y;
distLeftEyeToNose = features.nose.y - features.leftEye.y;
distRightEyeToNose = features.nose.y - features.rightEye.y;
mouthNoseOffset = features.nose.x - features.mouth.x; % negative if face tilted left, pos if right

scaleA = 0.8;
scaleB = 0.6;

points = [
    features.eyePair.x, features.eyePair.y;
    features.eyePair.x, features.eyePair.y - distEyesToNose * scaleA;
    
    features.leftEye.x, features.leftEye.y;
    features.leftEye.x - distLeftEyeToCenter * scaleA, features.leftEye.y;
    features.leftEye.x, features.leftEye.y - distLeftEyeToNose * scaleA;
    features.leftEye.x - distLeftEyeToCenter * scaleA, features.leftEye.y - distLeftEyeToNose * scaleB;
    
    features.rightEye.x, features.rightEye.y;
    features.rightEye.x + distRightEyeToCenter * scaleA, features.rightEye.y;
    features.rightEye.x, features.rightEye.y - distRightEyeToNose * scaleA;
    features.rightEye.x + distRightEyeToCenter * scaleA, features.rightEye.y - distRightEyeToNose * scaleB;
    
    features.nose.x, features.nose.y;
    features.nose.x - distLeftEyeToCenter * 1.5, features.nose.y;
    features.nose.x + distRightEyeToCenter * 1.5, features.nose.y;
    
    features.mouth.x, features.mouth.y;
    features.mouth.x - ((distLeftEyeToCenter - mouthNoseOffset) * 1.5), features.mouth.y;
    features.mouth.x + ((distRightEyeToCenter + mouthNoseOffset) * 1.5), features.mouth.y;
    features.mouth.x, features.mouth.y + distMouthToNose * scaleB;
];

x = points(:,1);
y = points(:,2);
cHull = convhull(x,y);

% figure('name', 'ConvexHull and Points');imshow(face);
% hold on; 
% plot(x, y,'r.','MarkerSize',20); 
% plot(x(cHull),y(cHull),'r-',x,y,'b*');

disp('ending get_convex_hull');

end

