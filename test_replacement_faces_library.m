% Plan: run through all pics of my face
% See what the most reliable features are
% Detect face
% Find features within face box
% Take them out to find them in the wider image
% Store images and features

% Read files mat1.mat through mat20.mat, file1.txt through file20.txt, 
% and image1.jpg through image20.jpg.  Files are in the current directory.
% Use fullfile() if you need to prepend some other folder to the base file name.
% Adapt to use which ever cases you need.
for k = 1:9
    % Create an image filename, and read it in to a variable called imageData.
	jpgFileName = strcat('replacement_faces2/face', num2str(k), '.jpg');
	if (exist(jpgFileName, 'file'))
        image = imread(jpgFileName);
        
        % Create a FACE cascade detector object.
        faceDetector = vision.CascadeObjectDetector();
        % Get bounding boxes of faces
        bboxes = step(faceDetector, image);    
        % Let user choose which face to replace
        [face] = let_user_choose_feature(image, bboxes);
        % Detect facial features
        [features] = get_facial_features(face);
        % Get convex hull
        [x,y,convhull] = get_convex_hull(features, face);
       
        %% SHOW
        figure('name', 'ConvexHull and Points');imshow(face);
        hold on; 
        plot(x, y,'r.','MarkerSize',20); 
        plot(x(convhull),y(convhull),'r-',x,y,'b*');

    else
        fprintf('File %s does not exist.\n', jpgFileName);
    end
end