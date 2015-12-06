I = imread('mask.png');
unique(I)

I(I>0) = 1;
unique(I)
