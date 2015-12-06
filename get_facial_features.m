function [ features ] = get_facial_features(image, face, faceBox)
% GET FACIAL FEATURES

%% Detect eyes
[eyePairRow, eyePairCol] = get_single_feature(face, faceBox, 'EyePairBig');
[leftEyeRow, leftEyeCol] = get_single_feature(face, faceBox, 'LeftEye', int16(eyePairCol));
[rightEyeRow, rightEyeCol] = get_single_feature(face, faceBox, 'RightEye', int16(eyePairCol));

%% Detect Nose
[noseRow, noseCol] = get_single_feature(face, faceBox, 'Nose', int16(eyePairRow));

%% Detect Mouth
[mouthRow, mouthCol] = get_single_feature(face, faceBox, 'Mouth', int16(noseRow));

xpoints = [eyePairCol, leftEyeCol, rightEyeCol, noseCol, mouthCol];
ypoints = [eyePairRow, leftEyeRow, rightEyeRow, noseRow, mouthRow];

% Offset coordinates by face offset
xpoints = xpoints + faceBox(1);
ypoints = ypoints + faceBox(2);

% Draw facebox on image
imageWithBox = insertShape(image, 'Rectangle', faceBox);

figure; imshow(imageWithBox); hold on;
plot(xpoints, ypoints,'r.','MarkerSize',20);

features = [xpoints', ypoints'];

end

