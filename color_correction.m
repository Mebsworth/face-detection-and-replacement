function [ im2Adjusted ] = color_correction( im1, im2 )
% COLOR CORRECTION 
%   Using histograms to adjust replacement face color & lighting to fit the
%   original face better

im1R = im1(:,:,1);
im1G = im1(:,:,2);
im1B = im1(:,:,3);

im2R = im2(:,:,1);
im2G = im2(:,:,2);
im2B = im2(:,:,3);

% figure; 
% subplot(2,3,1); imhist(im1R);
% subplot(2,3,2); imhist(im1G);
% subplot(2,3,3); imhist(im1B);
% subplot(2,3,4); imhist(im2R);
% subplot(2,3,5); imhist(im2G);
% subplot(2,3,6); imhist(im2B);

[redCounts,redBinLocations] = imhist(im1R);
[greenCounts,greenBinLocations] = imhist(im1G);
[blueCounts,blueBinLocations] = imhist(im1B);

im2AdjustedRed = histeq(im2(:,:,1),redCounts);
im2AdjustedGreen = histeq(im2(:,:,2),greenCounts);
im2AdjustedBlue = histeq(im2(:,:,3),blueCounts);

im2Adjusted = cat(3, im2AdjustedRed, im2AdjustedGreen, im2AdjustedBlue);

% figure;
% subplot(1,2,1); imshow(im2);
% subplot(1,2,2); imshow(im2Adjusted);


end

