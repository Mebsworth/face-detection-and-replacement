
%% Initialize 
% Read in image
filename = 'test_videos/easy/easy1.mp4';
videoFileReader = vision.VideoFileReader(filename);
videoFrame      = step(videoFileReader);

% Detect face
[faceTarget, bboxTarget] = detect_face_with_user_input(videoFrame);
features = get_facial_features(faceTarget);
featurePoints = features_to_points(features, bboxTarget(1), bboxTarget(2));
figure;imshow(faceTarget); hold on; plot(featurePoints(:,1), featurePoints(:,2), 'r.', 'MarkerSize',20);
% Convert the first box into a list of 4 points
% This is needed to be able to visualize the rotation of the object.
bboxPoints = bbox2points(bboxTarget(1, :));

% Get face width and height
targetWidth = bboxTarget(3);
targetHeight = bboxTarget(4);

% Set up replacement library of faces
numReplacementFaces = 9;
[ replacementFaces, rX, rY, rHulls, rFeatures ] = set_up_replacement_library(targetWidth, targetHeight, numReplacementFaces);

% Create a VideoWriter to make output video
v = VideoWriter('output_video','MPEG-4');
open(v);

% Detect feature points in the face region.
points = detectMinEigenFeatures(rgb2gray(videoFrame), 'ROI', bboxTarget);

% Create a point tracker and enable the bidirectional error constraint to
% make it more robust in the presence of noise and clutter.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Initialize the tracker with the initial point locations and the initial
% video frame.
points = points.Location;
initialize(pointTracker, points, videoFrame);

% Make a copy of the points to be used for computing the geometric
% transformation between the points in the previous and the current frames
oldPoints = points;
oldFeaturePoints = featurePoints;

% Counter to display which frame
i = 1;

%% Iterate through rest of frames
while ~isDone(videoFileReader)
%for k = 1:20
    % get the next frame
    videoFrame = step(videoFileReader);
    disp(strcat('Frame ',num2str(i)));
    i = i + 1;
    
    % Track the points. Note that some points may be lost.
    [points, isFound] = step(pointTracker, videoFrame);
    visiblePoints = points(isFound, :);
    oldInliers = oldPoints(isFound, :);
    
    if size(visiblePoints, 1) >= 2 % need at least 2 points
        
        % Estimate the geometric transformation between the old points
        % and the new points and eliminate outliers
        [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
            oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);

        % Apply the transformation to the bounding box points
        bboxPoints = transformPointsForward(xform, bboxPoints); 
        % Apply the transformation to the feature points
        featurePoints = transformPointsForward(xform, oldFeaturePoints);

        % Insert a bounding box around the object being tracked
        bboxPolygon = reshape(bboxPoints', 1, []);
%         videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, ...
%             'LineWidth', 2);
        
        %% REPLACE DA FACE
        % Extract face from image
        x1 = uint16(bboxPoints(1,1));
        x2 = uint16(bboxPoints(2,1));
        y1 = uint16(bboxPoints(1,2));
        y2 = uint16(bboxPoints(3,2));
        currentFace = videoFrame(y1:y2,x1:x2,:);
        features = points_to_features(featurePoints, bboxPoints(1,1), bboxPoints(1,2));
        blendedFace = replace_face(currentFace, features, replacementFaces, rX, rY, rHulls, rFeatures);
        blendedFace(blendedFace < 0) = 0;
        blendedFace(blendedFace > 1) = 1;
        blendedFace = im2single(blendedFace);
        videoFrame(y1:y2, x1:x2,:) = blendedFace;
        %figure;imshow(blendedFace);
        %videoFrame = insertShape(videoFrame, 'Rectangle', newBboxTarget);
        videoFrame = im2single(videoFrame);

        % Draw the returned bounding box around the detected face.
        % videoFrame = insertShape(videoFrame, 'Rectangle', newBbox);
        %figure; imshow(videoFrame); hold on; plot(featurePoints(:,1), featurePoints(:,2), 'r*', 'MarkerSize', 20);
        writeVideo(v,videoFrame);

        % Reset the points
        oldPoints = visiblePoints;
        oldFeaturePoints = featurePoints;
        setPoints(pointTracker, oldPoints);
    end

end
 
% Clean up
release(videoFileReader);

close(v);

