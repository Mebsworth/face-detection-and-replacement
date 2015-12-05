function [ bbox, videoFrameWithBox ] = let_user_choose_feature( videoFrame, bboxes )
% LET USER CHOOSE FACE 
%   Allows user to click within a bounding box of a face to choose to
%   replace it

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
    close

end

