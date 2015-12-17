function [ face, bbox ] = detect_face( image )
% DETECT FACE
% Given an image, this function detects faces, lets user choose a face, and
% then returns the face chosen

disp('beginning detect_face');
% Create a FACE cascade detector object.
faceDetector = vision.CascadeObjectDetector();
% Get bounding boxes of faces
bboxes = step(faceDetector, image);  

%% SHOW
%imageWithBoxes = insertShape(image, 'Rectangle',bboxes);
%figure;imshow(imageWithBoxes);

%% Choose face
bbox = bboxes(1,:);

%% Extract face from image
x1 = bbox(1,1);
x2 = bbox(1,3);
y1 = bbox(1,2);
y2 = bbox(1,4);
% Expand
x1 = x1 - 20;
x2 = x2 + 40;
y1 = y1 - 20;
y2 = y2 + 40;
bbox = [x1, y1, x2, y2];
face = image(y1:(y1+y2), x1:(x1+x2),:);

disp('ending detect_face');

end


