I=imread('D:\BE Electrical Engineering\Medical Imaging\Project\Brain_Tumor\Brain_Tumor_Code\Malignant\6Perfect.jpg');
figure, imshow(I); title('Brain MRI Image');

figure, imshow(I);title('Thresholded Image');
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
L = watershed(gradmag);
Lrgb = label2rgb(L);
figure, imshow(Lrgb), title('Watershed segmented image ')
se = strel('disk', 20);
Io = imopen(I, se);
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
I2 = I;
fgm = imregionalmax(Iobrcbr);
I2(fgm) = 255;
se2 = strel(ones(5,5));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);
fgm4 = bwareaopen(fgm3, 20);
I3 = I;
bw = im2bw(Iobrcbr);
figure
imshow(bw), title('only tumor')