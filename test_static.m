%imageA = imread('img/face6.jpg');

filename = 'img/clip9.mp4';
%filename = 'test_videos/medium/medium2.mp4';
videoFileReader = vision.VideoFileReader(filename);
videoFrame      = step(videoFileReader);
imageA = videoFrame;

resized = 0;

% Detect face
[~, bbox] = detect_face_with_user_input(imageA);
[faceA, bbox] = expand_face(imageA, bbox);

width = bbox(3);
height = bbox(4);

if (width < 200) || (height < 200)
    faceA = imresize(faceA, [200,200]);
    resized = 1;
end

featuresA = get_facial_features(faceA);

% show convex hull of A
% [ x,y,cHull, xE, yE, expandedHull ] = get_convex_hull( featuresA, faceA );
% figure;imshow(faceA); hold on;
% plot(x(cHull),y(cHull),'b-');

% Set up replacement library of faces
[ replacementFaces, rX, rY, rHulls, rFeatures ] = set_up_replacement_library(width, height,9);

x1 = bbox(1);
x2 = bbox(3);
y1 = bbox(2);
y2 = bbox(4);

blendedFace = replace_face(faceA, featuresA, replacementFaces, rX, rY, rHulls, rFeatures);
figure;imshow(blendedFace);
if (resized)
    blendedFace = imresize(blendedFace, [height+1, width+1]);
end

imageA(y1:(y1+y2), x1:(x1+x2),:) = im2double(blendedFace);


figure;imshow(imageA);

release(videoFileReader);