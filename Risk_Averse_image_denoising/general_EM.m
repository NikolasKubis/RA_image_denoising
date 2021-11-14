p = 6;
xmin=0;
xmax=1;
n=10000;
X = xmin + (xmax - xmin)*sum(rand(n,p),2)/p; % to sum dinei ena 
% vector 10000X1 to opoio einai! sa na exei deigmatoliptithei apo normal
% dist. 
hist(X,50) % 50= number of bins.



%
%
%
close all;
clear all;
colored_image=imread('lenna.png');
%The colored image is a nXmX3 array of numbers. The latter dimension
%denotes the RGB of the image. 
%Check: https://www.youtube.com/watch?v=nAVgUfk-ALE&ab_channel=MATLAB
gray_image=rgb2gray(colored_image);
figure(1)
imshow(colored_image);
figure(2)
imshow(gray_image);
title("Lenna Gray")
%On the contrary, converting the image into a gray image we eliminate the
%latter dimension and the picture is a two simensional array which can be 
% patched into vectors.

figure(3)
imhist(gray_image)
%The x-axis of the intensity(!) histogram represents the intensity values
%while the y-axis is the pixel count.

%How to show part of the image...
croppedImage = gray_image(1:10, 1:10);
figure(4)
imshow(croppedImage);

% The imtool command depicts the image and offers a detailed description of
% it.
imtool(gray_image)

%The commant im2double rescales the output from integer data types
%to the range [0, 1] (!!!!).
image_double=im2double(gray_image);

%So if I want to add (Gaussian) noise to this image, I have to limit the
%noise values within the interval [0,1]. In order to do so, I employ the 
% Central Limit Theorem (CLT).

A=sum(rand(512,512,500,10),4)/10;

% add noise as usual. 
noisy_image=image_double+0.1*randn(512,512);
figure(5)
imshow(noisy_image)

%But, how you create normal random numbers within specific limits?
