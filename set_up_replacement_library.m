function [ replacementFaces, X, Y, rHulls, rFeatures ] = set_up_replacement_library(width, height, numReplacementFaces)
% SET UP REPLACEMENT LIBRARY 

nrf = numReplacementFaces;
replacementFaces = cell(1,nrf);
X = cell(1,nrf);
Y = cell(1,nrf);
rHulls = cell(1,nrf);
rFeatures = cell(1,nrf);

    %% Iterate through faces
    for i = 1:nrf
        imageFilePath = strcat('replacement_faces/face', num2str(i), '.jpg');
        if (exist(imageFilePath, 'file'))
            image = imread(imageFilePath);
            [faceB, bboxB] = detect_face(image);
            %[faceB, bboxB] = expand_face(image, bboxB);
            faceB = imresize(faceB, [height, width]);
            % Detect facial features
            [featuresB] = get_facial_features(faceB);
            % Get convex hull
            [Bx,By,convhullB, BxE, ByE, expandedHull] = get_convex_hull(featuresB, faceB);
            replacementFaces{i} = faceB;
            X{i} = Bx;
            Y{i} = By;
            rHulls{i} = convhullB;
            rFeatures{i} = featuresB;
            
            %% Show 
            %figure;imshow(faceB);
            %hold on; 
            %featPoints = features_to_points(featuresB, 0, 0);
            %plot(featPoints(:,1), featPoints(:,2), 'r.', 'MarkerSize', 20);
            %plot(x, y,'r.','MarkerSize',20); 
            %plot(x(cHull),y(cHull),'r-',x,y,'b*');
            %plot(Bx(convhullB),By(convhullB),'b-');

            %plot(xE, yE, 'g.', 'MarkerSize', 20);
            %plot(xE(expandedHull),yE(expandedHull),'g-',xE,yE,'g*');
            %plot(BxE(expandedHull),ByE(expandedHull),'g-');
        else
            fprintf('File %s does not exist.\n', jpgFileName);
        end
    end

end

