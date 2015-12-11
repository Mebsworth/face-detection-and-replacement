function [ features ] = get_facial_features(face)
% GET FACIAL FEATURES

disp('beginning get_facial_features');

%% Detect eyes
[eyePairRow, eyePairCol] = get_single_feature(face, 'EyePairBig');
[leftEyeRow, leftEyeCol] = get_single_feature(face, 'LeftEye', int16(eyePairCol));
[rightEyeRow, rightEyeCol] = get_single_feature(face, 'RightEye', int16(eyePairCol));

%% Detect Nose
[noseRow, noseCol] = get_single_feature(face, 'Nose', int16(eyePairRow));

%% Detect Mouth
[mouthRow, mouthCol] = get_single_feature(face, 'Mouth', int16(noseRow));

% xpoints = [eyePairCol, leftEyeCol, rightEyeCol, noseCol, mouthCol];
% ypoints = [eyePairRow, leftEyeRow, rightEyeRow, noseRow, mouthRow];

features.eyePair.x = eyePairCol; 
features.eyePair.y = eyePairRow;

features.leftEye.x = leftEyeCol;
features.leftEye.y = leftEyeRow;

features.rightEye.x = rightEyeCol;
features.rightEye.y = rightEyeRow;

features.nose.x = noseCol; 
features.nose.y = noseRow;

features.mouth.x = mouthCol;
features.mouth.y = mouthRow;

disp('ending get_facial_features');

end

