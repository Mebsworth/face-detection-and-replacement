function [ replacementFaces, X, Y, rHulls, rFeatures ] = set_up_replacement_library(width, height)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

replacementFaces = cell(1,6);
X = cell(1,6);
Y = cell(1,6);
rHulls = cell(1,6);
rFeatures = cell(1,6);

    %% Iterate through faces
    for i = 1:6
        imageFilePath = strcat('replacement_faces/face', num2str(i), '.jpg');
        if (exist(imageFilePath, 'file'))
            image = imread(imageFilePath);
            [faceB, bboxB] = detect_face(image);
            [faceB, bboxB] = expand_face(image, bboxB);
            faceB = imresize(faceB, [height, width]);
            % Detect facial features
            [featuresB] = get_facial_features(faceB);
            % Get convex hull
            [Bx,By,convhullB] = get_convex_hull(featuresB, faceB);
            replacementFaces{i} = faceB;
            X{i} = Bx;
            Y{i} = By;
            rHulls{i} = convhullB;
            rFeatures{i} = featuresB;
        else
            fprintf('File %s does not exist.\n', jpgFileName);
        end
    end

end

