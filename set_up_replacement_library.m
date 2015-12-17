function [ replacementFaces, X, Y, rHulls, rFeatures ] = set_up_replacement_library(width, height, numReplacementFaces)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
nrf = numReplacementFaces;
replacementFaces = cell(1,nrf);
X = cell(1,nrf);
Y = cell(1,nrf);
rHulls = cell(1,nrf);
rFeatures = cell(1,nrf);

    %% Iterate through faces
    for i = 1:nrf
        imageFilePath = strcat('replacement_faces2/face', num2str(i), '.jpg');
        if (exist(imageFilePath, 'file'))
            image = imread(imageFilePath);
            [faceB, bboxB] = detect_face(image);
            %[faceB, bboxB] = expand_face(image, bboxB);
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

