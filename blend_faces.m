function [ blendedFace ] = blend_faces( im1, im2, mask )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

disp('beginning blend_faces');

%% Get sigma value for blurring from size of image
% images are the same size at this point
[y,x,~] = size(im1);
sigma = x / 110;

mask = double(repmat(mask,[1,1,3]));
blurredMask = imgaussfilt(mask,11);
im1_low = imgaussfilt(im1, sigma);
im2_low = imgaussfilt(im2, sigma);

im1_high = im1 - im1_low;
im2_high = im2 - im2_low;


I_blend_high = (im1_high .* (imcomplement(mask))) + (im2_high .* mask);
I_blend_low = (im1_low .* (imcomplement(blurredMask))) + (im2_low .* blurredMask);

blendedFace = (I_blend_high + I_blend_low);
%blendedFace = I_blend_high;

disp('ending blend_faces');
end

