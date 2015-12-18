function [ features ] = get_facial_features(face)
% GET FACIAL FEATURES

% disp('beginning get_facial_features');
[nr, nc, ~] = size(face);

%% Detect eyes
[eyePairRow, eyePairCol] = get_single_feature(face, 'EyePairBig');
if (int16(eyePairRow) == 0) || (int16(eyePairCol) == 0)
    [eyePairRow, eyePairCol] = get_single_feature(face, 'EyePairSmall');
end
if (int16(eyePairRow) == 0)
    eyePairRow = nc/3;
    eyePairCol = nr/2;
end
[leftEyeRow, leftEyeCol] = get_single_feature(face, 'LeftEye', int16(eyePairCol));
[rightEyeRow, rightEyeCol] = get_single_feature(face, 'RightEye', int16(eyePairCol));

%% Detect Nose
[noseRow, noseCol] = get_single_feature(face, 'Nose', int16(eyePairRow));

%% Detect Mouth
[mouthRow, mouthCol] = get_single_feature(face, 'Mouth', int16(noseRow));

% xpoints = [eyePairCol, leftEyeCol, rightEyeCol, noseCol, mouthCol];
% ypoints = [eyePairRow, leftEyeRow, rightEyeRow, noseRow, mouthRow];

% Eye Pair
features.eyePair.x = eyePairCol; 
features.eyePair.y = eyePairRow;

% Left Eye
features.leftEye.x = leftEyeCol;
features.leftEye.y = leftEyeRow;

% Right Eye
features.rightEye.x = rightEyeCol;
features.rightEye.y = rightEyeRow;

% Nose
features.nose.x = noseCol; 
features.nose.y = noseRow;

% Mouth
features.mouth.x = mouthCol;
features.mouth.y = mouthRow;

% disp('ending get_facial_features');

end

