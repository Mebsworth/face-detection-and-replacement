function [ face, bbox ] = detect_face_with_user_input( image )
% DETECT FACE
% Given an image, this function detects faces, lets user choose a face, and
% then returns the face chosen

% Create a FACE cascade detector object.
faceDetector = vision.CascadeObjectDetector();
% Get bounding boxes of faces
bboxes = step(faceDetector, image);    
% Let user choose which face to replace
[face, bbox]= let_user_choose_feature(image, bboxes);

end

