function [ imageWithBoxes, leftEyeBox, rightEyeBox, eyeBox, mouthBox, noseBox] = get_facial_features(image, face, faceBox)
% GET FACIAL FEATURES

%% Detect eyes
[leftEyeRow, leftEyeCol] = get_single_feature(image, face, faceBox, 'LeftEye');
[rightEyeRow, rightEyeCol] = get_single_feature(image, face, faceBox, 'RightEye');
[eyePairRow, eyePairCol] = get_single_feature(image, face, faceBox, 'EyePairBig');

%% Detect Nose
[noseRow, noseCol] = get_single_feature(image, face, faceBox, 'Nose');

%% Detect Mouth
[mouthRow, mouthCol] = get_single_feature(image, face, faceBox, 'Mouth');


%xpoints = [leftEyeRow, rightEyeRow, eyePairRow, noseRow, mouthRow];
%ypoints = [leftEyeCol, rightEyeCol, eyePairCol, noseCol, mouthCol];

%figure; imshow(image); hold on;
%plot(xpoints, ypoints,'r.','MarkerSize',20);

% rightEyeDetector = vision.CascadeObjectDetector('ClassificationModel', 'RightEye');
% rightEyeBoxes = step(rightEyeDetector, face);
% [rightEyeBox, videoFrameWithEyeBox, rightEye] = let_user_choose_feature(face, rightEyeBoxes);
% 
% bothEyesDetector = vision.CascadeObjectDetector('ClassificationModel', 'EyePairBig');
% eyeBoxes = step(bothEyesDetector, face);
% [eyeBox, videoFrameWithEyeBox, eyes] = let_user_choose_feature(face, eyeBoxes);
% 
% %% Detect mouth
% mouthDetector = vision.CascadeObjectDetector('ClassificationModel', 'Mouth');
% mouthBoxes = step(mouthDetector, face);
% [mouthBox, videoFrameWithMouthBox, mouth] = let_user_choose_feature(face, mouthBoxes);
% 
% %% Detect nose
% noseDetector = vision.CascadeObjectDetector('ClassificationModel', 'Nose');
% noseBoxes = step(noseDetector, face);
% [noseBox, videoFrameWithNoseBox, nose] = let_user_choose_feature(face, noseBoxes);
% 
% %% Show all detected features
% imageWithBoxes = insertShape(face, 'Rectangle', eyeBox);
% imageWithBoxes = insertShape(imageWithBoxes, 'Rectangle', leftEyeBox);
% imageWithBoxes = insertShape(imageWithBoxes, 'Rectangle', rightEyeBox);
% imageWithBoxes = insertShape(imageWithBoxes, 'Rectangle', mouthBox);
% imageWithBoxes = insertShape(imageWithBoxes, 'Rectangle', noseBox);
% figure; imshow(imageWithBoxes);


end

