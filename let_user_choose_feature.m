function [ feature, bbox ] = let_user_choose_feature( videoFrame, bboxes )
% LET USER CHOOSE FACE 
%   Allows user to click within a bounding box of a face to choose to
%   replace it

% disp('beginning let_user_choose_feature');

    % Draw the returned bounding boxes around the detected faces.
    videoFrameWithBox = insertShape(videoFrame, 'Rectangle', bboxes);
    figure('name', 'Choose a face to replace!'); imshow(videoFrameWithBox);
    
    % Let user choose which face to replace
    [num_boxes, ~] = size(bboxes);
    bbox = 0;
    [x,y] = ginput(1);
    for i = 1:num_boxes
        current = bboxes(i,:);
        if (x >= current(1) && (x < (current(1) + current(3))))
            if (y >= current(2) && (y < (current(2) + current(4))))
                bbox = current;
            end
        end
    end
    
    if (bbox == 0)
        close
        bbox = let_user_choose_face(videoFrame, bboxes);
    end
    
    % Extract face from image
    x1 = bbox(1,1);
    x2 = bbox(1,3);
    y1 = bbox(1,2);
    y2 = bbox(1,4);
    feature = videoFrame(y1:(y1+y2), x1:(x1+x2),:);
    
    close
    
%     disp('ending let_user_choose_feature');

end

