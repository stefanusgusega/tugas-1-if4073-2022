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
    for d = 1:depth
        imgArr = imgIn(:,:,d);
        hist = image_histogram(imgArr);
        %disp(hist)
        %disp(hist(200));

        % create T(rk) 
        histFunc = zeros(256,1);

        % calculate probability for each rk
        for i = 1:256 
            sum = 0;
            for j = 1:i
                sum = sum + hist(j)/n;
            end
            histFunc(i) = floor(sum*255);
        end
        
        % transform image based on T(rk)
        for i = 1:row
            for j = 1:col
                imgOut(i,j,d) = histFunc(imgArr(i,j)+1);
            end
        end
        %disp(max(imgArr(:)));
        %disp(min(imgArr(:)));
            %figure,bar(histFunc);
        figure,image_histogram(imgOut(:,:,d));
        figure,image_histogram(histeq(imgArr));
        %hix(:,:,d) = histeq(imgArr);
    end
    figure,imshow(imgIn);
    figure,imshow(imgOut);
    %figure,imshow(hix);
end