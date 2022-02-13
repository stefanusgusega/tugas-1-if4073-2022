function [imgOut] = histogram_equalization(fileName)
%HISTOGRAM_EQUALIZATION Summary of this function goes here
%   Detailed explanation goes here

    % read image
    imgIn = imread(fileName);

    % output initialization
    imgOut = imgIn;
    %hix = imgIn;

    % image size
    [row, col, depth] = size(imgIn);
    n = row * col;
    disp(size(imgIn));
    
    % for each color
    % for d = 1:depth
    
    %imgArr = imgIn(:,:,d);
    histogram = image_histogram(imgIn);
    %disp(hist)
    %disp(hist(200));

    % create T(rk) 
    histFunc = transform(histogram, n);
    
    % transform image based on T(rk)
    for i = 1:row
        for j = 1:col
            imgOut(i,j) = histFunc(imgIn(i,j)+1);
        end
    end

    %disp(max(imgArr(:)));
    %disp(min(imgArr(:)));

    figure,image_histogram(imgOut);
    figure,image_histogram(histeq(imgIn));
    %hix(:,:,d) = histeq(imgArr);
    %end
    figure,imshow(imgIn);
    figure,imshow(imgOut);
    %figure,imshow(hix);
end