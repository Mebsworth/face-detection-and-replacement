
%% Initialize 
% Read in image
%filename = 'test_videos/easy/easy1.mp4';
filename = 'test_clips/clip1.mp4';
videoFileReader = vision.VideoFileReader(filename);
videoFrame      = step(videoFileReader);

%% Detect face
[faceTarget, bboxTarget] = detect_face_with_user_input(videoFrame);
features = get_facial_features(faceTarget);
featurePoints = features_to_points(features, bboxTarget(1), bboxTarget(2));

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
%         bboxPolygon = reshape(bboxPoints', 1, []);
%          videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, ...
%              'LineWidth', 2);
         %videoFrame = insertShape(videoFrame, 'Circle', cat(2,featurePoints,[3;3;3;3;3]));
        
        %% REPLACE DA FACE
        % Extract face from image
        x1 = uint16(bboxPoints(1,1));
        x2 = uint16(bboxPoints(2,1));
        y1 = uint16(bboxPoints(1,2));
        y2 = uint16(bboxPoints(3,2));
        currentFace = videoFrame(y1:y2,x1:x2,:);
        % Convert feature points back into Features struct
        features = points_to_features(featurePoints, bboxPoints(1,1), bboxPoints(1,2));
               
        % Get blended face
        blendedFace = replace_face(currentFace, features, replacementFaces, rX, rY, rHulls, rFeatures);
       
        % Make sure all values are within 0-1 and face is of type single
        blendedFace(blendedFace < 0) = 0;
        blendedFace(blendedFace > 1) = 1;
        blendedFace = im2single(blendedFace);
        % Insert new face into frame
        videoFrame(y1:y2, x1:x2,:) = blendedFace;
        videoFrame = im2single(videoFrame);

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

