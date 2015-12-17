function [ x1, y1, x2, y2, width, height ] = get_coordinates_from_bounding_box( bbox )
% GET COORDINATES FROM BOUNDING BOX

x1 = bbox(1);
y1 = bbox(2);

width = bbox(3);
height = bbox(4);

x2 = x1 + width;
y2 = y1 + height;

end

