%imageA = imread('img/face6.jpg');

filename = 'img/clip1.mp4';
videoFileReader = vision.VideoFileReader(filename);
videoFrame      = step(videoFileReader);
imageA = videoFrame;

% Detect face
[faceA, bbox] = detect_face_with_user_input(imageA);
[faceA, bbox] = expand_face(imageA, bbox);

width = bbox(3);
height = bbox(4);
% Set up replacement library of faces
[ replacementFaces, rX, rY, rHulls, rFeatures ] = set_up_replacement_library(width, height);

x1 = bbox(1);
x2 = bbox(3);
y1 = bbox(2);
y2 = bbox(4);
blendedFace = replace_face(faceA, replacementFaces, rX, rY, rHulls, rFeatures);
figure;imshow(blendedFace);
imageA(y1:(y1+y2), x1:(x1+x2),:) = im2uint8(blendedFace);


%figure;imshow(imageA);

release(videoFileReader);