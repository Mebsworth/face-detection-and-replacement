function [  ] = vl_feat_detection( filename )

    % Create a cascade detector object.
    faceDetector = vision.CascadeObjectDetector();
    
    % Create a video file reader object and extract first frame
    videoFileReader = vision.VideoFileReader(filename);
    videoFrame      = step(videoFileReader);
    I = videoFrame;
    figure('name', 'image'); imshow(I);
    
    % Get bounding box of face
    bbox = step(faceDetector, videoFrame);
    
    % Draw the returned bounding box around the detected face.
    videoFrameWithBox = insertShape(videoFrame, 'Rectangle', bbox);
    figure('name', 'Found Face'); imshow(videoFrameWithBox);

    % SIFT within Bounding Box of Face
    I = single(rgb2gray(I));
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

    % perm = randperm(size(f,2)) ;
    % sel = perm(1:50) ;
    % h1 = vl_plotframe(f(:,sel)) ;
    % h2 = vl_plotframe(f(:,sel)) ;
    figure('name', 'SIFT'); imshow(videoFrameWithBox);
    h1 = vl_plotframe(frames);
    h2 = vl_plotframe(frames);
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;

    %h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
    h3 = vl_plotsiftdescriptor(descrips,frames);
    set(h3,'color','g') ;

end

