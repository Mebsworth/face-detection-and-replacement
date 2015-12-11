% Read in image
filename = 'img/clip1.mp4';
videoFileReader = vision.VideoFileReader(filename);
videoFrame      = step(videoFileReader);
imageA = videoFrame;

% Detect face
[faceA, oldBbox] = detect_face_with_user_input(imageA);
width = oldBbox(3);
height = oldBbox(4);

v = VideoWriter('output_video','MPEG-4');
open(v);

i = 1;

%while ~isDone(videoFileReader)
for k = 1:15
    % get the next frame
    videoFrame = step(videoFileReader);
    disp(strcat('Frame ',num2str(i)));
    i = i + 1;
    
    % Detect new bounding box for face within ROI REGION OF INTEREST
    roi_x1 = oldBbox(1) - 30;
    roi_y1 = oldBbox(2) - 30;
    roi_x2 = oldBbox(1) + oldBbox(3) + 30;
    roi_y2 = oldBbox(2) + oldBbox(4) + 30;
    smaller_region = videoFrame(roi_y1:roi_y2, roi_x1:roi_x2);
    [ newFace, newBbox ]= detect_face(smaller_region);
    % remember these are offset, let's undo the offset
    newBbox = [roi_x1 + newBbox(1), roi_y1 + newBbox(2), newBbox(3), newBbox(4)];
    % expand newFace and newBox
    [ currentFace, newBbox ] = expand_face(videoFrame, newBbox);
    newBbox
    % Detect facial features
    [features] = get_facial_features(currentFace);
    % Find convex hull of face
    [Ax,Ay,convhullA] = get_convex_hull(features, currentFace);
    
    figure;imshow(currentFace); hold on; plot(Ax,Ay,'r.','MarkerSize',20);
    
%     %% REPLACE DA FACE
%     blendedFace = replace_face(currentFace, replacementFaces, rX, rY, rHulls, rFeatures);
%     x1 = newBbox(1);
%     y1 = newBbox(2);
%     x2 = newBbox(3);
%     y2 = newBbox(4);
%     videoFrame(y1:(y1+y2), x1:(x1+x2),:) = blendedFace;

    % Draw the returned bounding box around the detected face.
    videoFrame = insertShape(videoFrame, 'Rectangle', newBbox);
    
    writeVideo(v,videoFrame);
    oldBbox = newBbox;

end
 
% Clean up
release(videoFileReader);

close(v);

