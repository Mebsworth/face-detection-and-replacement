
% Read in image
filename = 'img/clip1.mp4';
videoFileReader = vision.VideoFileReader(filename);
videoFrame      = step(videoFileReader);
image1 = videoFrame;

%% Detect face
% Create a FACE cascade detector object.
faceDetector = vision.CascadeObjectDetector();
% Get bounding boxes of faces
bboxes = step(faceDetector, image1);    
% Let user choose which face to replace
[bbox, videoFrameWithBox, face] = let_user_choose_feature(image1, bboxes);

get_facial_features(image1, face, bbox);

%% Detect facial features
%[ imageWithBoxes, leftEyeBox, rightEyeBox, eyeBox, mouthBox, noseBox] = get_facial_features(face);


