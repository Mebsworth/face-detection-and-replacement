function [ x,y,cHull, xE, yE, expandedHull ] = get_convex_hull( features, face )

% disp('beginning get_convex_hull');

distEyesToNose = features.nose.y - features.eyePair.y;
distLeftEyeToCenter = features.eyePair.x - features.leftEye.x;
distRightEyeToCenter = features.rightEye.x - features.eyePair.x;
distMouthToNose = features.mouth.y - features.nose.y;
distLeftEyeToNose = features.nose.y - features.leftEye.y;
distRightEyeToNose = features.nose.y - features.rightEye.y;
mouthNoseOffset = features.nose.x - features.mouth.x; % negative if face tilted left, pos if right

scale = [0.4, 0.6, 0.8, 1.1, 1.5];

points = [
    features.eyePair.x, features.eyePair.y;
    features.eyePair.x, features.eyePair.y - distEyesToNose * scale(4);
    
    features.leftEye.x, features.leftEye.y;
    features.leftEye.x - distLeftEyeToCenter * scale(2), features.leftEye.y;
    features.leftEye.x, features.leftEye.y - distLeftEyeToNose * scale(3);
    features.leftEye.x - distLeftEyeToCenter * scale(2), features.leftEye.y - distLeftEyeToNose * scale(2);
    
    features.rightEye.x, features.rightEye.y;
    features.rightEye.x + distRightEyeToCenter * scale(2), features.rightEye.y;
    features.rightEye.x, features.rightEye.y - distRightEyeToNose * scale(3);
    features.rightEye.x + distRightEyeToCenter * scale(2), features.rightEye.y - distRightEyeToNose * scale(2);
    
    features.nose.x, features.nose.y;
    features.nose.x - distLeftEyeToCenter * scale(5), features.nose.y;
    features.nose.x + distRightEyeToCenter * scale(5), features.nose.y;
    
    features.mouth.x, features.mouth.y;
    %features.mouth.x - ((distLeftEyeToCenter - mouthNoseOffset) * scaleC), features.mouth.y;
    %features.mouth.x + ((distRightEyeToCenter + mouthNoseOffset) * scaleC), features.mouth.y;
    features.leftEye.x - (distLeftEyeToCenter * scale(1)), features.mouth.y;
    features.rightEye.x + (distRightEyeToCenter * scale(1)), features.mouth.y;
    features.mouth.x, features.mouth.y + distMouthToNose * scale(2);
];

scaleE = scale + 0.2;

expandedPoints = [
    features.eyePair.x, features.eyePair.y;
    features.eyePair.x, features.eyePair.y - distEyesToNose * scaleE(4);
    
    features.leftEye.x, features.leftEye.y;
    features.leftEye.x - distLeftEyeToCenter * scaleE(2), features.leftEye.y;
    features.leftEye.x, features.leftEye.y - distLeftEyeToNose * scaleE(3);
    features.leftEye.x - distLeftEyeToCenter * scaleE(2), features.leftEye.y - distLeftEyeToNose * scaleE(2);
    
    features.rightEye.x, features.rightEye.y;
    features.rightEye.x + distRightEyeToCenter * scaleE(2), features.rightEye.y;
    features.rightEye.x, features.rightEye.y - distRightEyeToNose * scaleE(3);
    features.rightEye.x + distRightEyeToCenter * scaleE(2), features.rightEye.y - distRightEyeToNose * scaleE(2);
    
    features.nose.x, features.nose.y;
    features.nose.x - distLeftEyeToCenter * scaleE(5), features.nose.y;
    features.nose.x + distRightEyeToCenter * scaleE(5), features.nose.y;
    
    features.mouth.x, features.mouth.y;
%     features.mouth.x - ((distLeftEyeToCenter - mouthNoseOffset) * scaleC2), features.mouth.y;
%     features.mouth.x + ((distRightEyeToCenter + mouthNoseOffset) * scaleC2), features.mouth.y;
    features.leftEye.x - (distLeftEyeToCenter * scaleE(1)), features.mouth.y;
    features.rightEye.x + (distRightEyeToCenter * scaleE(1)), features.mouth.y;
    features.mouth.x, features.mouth.y + distMouthToNose * scaleE(2);
];

x = points(:,1);
y = points(:,2);
cHull = convhull(x,y);

xE = expandedPoints(:,1);
yE = expandedPoints(:,2);
expandedHull = convhull(xE, yE);
 
% figure('name', 'ConvexHull and Points');imshow(face);
% hold on; 
% plot(x, y,'r.','MarkerSize',20); 
% plot(x(cHull),y(cHull),'r-',x,y,'b*');
% 
% plot(xE, yE, 'g.', 'MarkerSize', 20);
% plot(xE(expandedHull),yE(expandedHull),'g-',xE,yE,'g*');

% disp('ending get_convex_hull');

end

