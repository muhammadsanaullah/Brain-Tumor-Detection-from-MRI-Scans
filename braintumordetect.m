close all;
clear all;
%%Giving input to the system
originalImage=imread('Y1.jpg');
figure;
subplot(2,2,1);
imshow(originalImage);
title('Original MRI Image');
%%% Pre-Processing of MRI Image
%%Converting Image to Grayscale
greyScale=rgb2gray(originalImage);
subplot(2,2,2);
imshow(greyScale);
title('Grey Scale Image');
%%High-Pass Filter
kernel = -1*ones(3);
kernel(2,2) = 9;
echancedImage = imfilter(greyScale, kernel);
subplot(2,2,3);
imshow(echancedImage);
title('After High-Pass Filter');
%%Median Filter
medianFiltered=medfilt2(echancedImage);
subplot(2,2,4);
imshow(medianFiltered);
title('After Median Filter');
%%% Segmentation & Structuring
%%Threshold Segmantation
BW = imbinarize(medianFiltered,0.6);
figure;
subplot(2,2,1);
imshow(BW);
title('Threshold Segmentation');
%Watershed Segmentation
I = imresize(originalImage,[200,200]);
I = rgb2gray(I);
I= im2bw(I,.6);%binarising with thresold .6
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
= sqrt(Ix.^2 + Iy.^2);
L = watershed(gradmag);
Lrgb = label2rgb(L);
subplot(2,2,2);
imshow(Lrgb), title('Watershed Segmentation');
%%Morphological Operations
se1=strel('disk', 2);
se2=strel('disk',20);
first=imclose(BW, se1);
second=imopen(first, se2);
subplot(2,2,3);
imshow(second);
title('After Morphological Structuring Operations');
%%Obtaining Red Circle Radius
stats = regionprops('table',second,'Centroid','MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = (diameters/2);
finalRadii=radii+40;
if radii > 5
%%Adding Images
%% Tumor found
K = im2uint8(second);
final=imadd(K, greyScale);
figure;
subplot(2,1,1);
imshow(greyScale);
title('Original Image');
subplot(2,1,2);
imshow(final, []);
viscircles(centers,finalRadii);
title('Detected Tumor');
else
%% Tumor not found
K = im2uint8(second);
final=imadd(K, greyScale);
figure;
subplot(2,1,1);
imshow(greyScale);
title('Original Image');
subplot(2,1,2);
imshow(final, []);
%viscircles(centers,radii);
title('No Tumor Detected');
end
