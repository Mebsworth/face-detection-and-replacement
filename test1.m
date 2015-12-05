
% Read in image
filename = 'clip1.mp4';
videoFileReader = vision.VideoFileReader(filename);
videoFrame      = step(videoFileReader);
image1 = videoFrame;

% Create a FACE cascade detector object.
faceDetector = vision.CascadeObjectDetector();

% Get bounding boxes of faces
bboxes = step(faceDetector, image1);
    
% Let user choose which face to replace
[bbox, videoFrameWithBox] = let_user_choose_feature(image1, bboxes);

% Extract face from image
x1 = bbox(1,1);
x2 = bbox(1,3);
y1 = bbox(1,2);
y2 = bbox(1,4);
face = image1(y1:(y1+y2), x1:(x1+x2),:);

figure; imshow(face);

%% Detect eyes
eyeDetector = vision.CascadeObjectDetector('ClassificationModel', 'EyePairBig');

eye_bboxes = step(eyeDetector, face);

[eye_bbox, videoFrameWithEyeBox] = let_user_choose_feature(face, eye_bboxes);

%% Detect mouth
mouthDetector = vision.CascadeObjectDetector('ClassificationModel', 'Mouth');

mouth_bboxes = step(mouthDetector, face);

[mouth_bbox, videoFrameWithMouthBox] = let_user_choose_feature(face, mouth_bboxes);

%% Detect nose
noseDetector = vision.CascadeObjectDetector('ClassificationModel', 'Nose');

nose_bboxes = step(noseDetector, face);

[nose_bbox, videoFrameWithNoseBox] = let_user_choose_feature(face, nose_bboxes);

