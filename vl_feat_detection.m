function [ frames, descrips, face, x1, y1 ] = vl_feat_detection( image )

    % Create a cascade detector object.
    faceDetector = vision.CascadeObjectDetector();
    
    % Create a video file reader object and extract first frame
   videoFrame = image;
    
    % Get bounding boxes of faces
    bboxes = step(faceDetector, videoFrame);
    
    % Let user choose which face to replace
    [bbox, videoFrameWithBox] = let_user_choose_face(videoFrame, bboxes);

    % SIFT within Bounding Box of Face
    I = single(rgb2gray(videoFrame));
    x1 = bbox(1,1);
    x2 = bbox(1,3);
    y1 = bbox(1,2);
    y2 = bbox(1,4);
    face = I(y1:(y1+y2), x1:(x1+x2),:);
    peak_thresh = 0.001;
    [frames,descrips] = vl_sift(face, 'PeakThresh', peak_thresh);
    
    % Offset features by bbox location
    frames(1,:) = frames(1,:) + x1;
    frames(2,:) = frames(2,:) + y1;

    % Plot frames and descriptors on image
    figure('name', 'SIFT'); imshow(videoFrameWithBox);
    h1 = vl_plotframe(frames);
    h2 = vl_plotframe(frames);
    set(h1,'color','k','linewidth',3);
    set(h2,'color','y','linewidth',2);
    h3 = vl_plotsiftdescriptor(descrips,frames);
    set(h3,'color','g');

end

