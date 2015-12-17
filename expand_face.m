function [ newFace, newBbox ] = expand_face( img, bbox )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

x1 = bbox(1);
y1 = bbox(2);
x2 = bbox(3);
y2 = bbox(4);

nx1 = x1 - 20;
ny1 = y1 - 20;
nx2 = x2 + 40;
ny2 = y2 + 40;

newFace = img(ny1:(ny1 + ny2),nx1:(nx1 + nx2), :);
% figure('name','expanded Face');imshow(newFace);
newBbox = [nx1 ny1 nx2 ny2];

end

