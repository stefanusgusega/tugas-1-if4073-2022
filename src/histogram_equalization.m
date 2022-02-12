function [imgOut] = histogram_equalization(fileName)
%HISTOGRAM_EQUALIZATION Summary of this function goes here
%   Detailed explanation goes here
    imgIn = imread(fileName);
    imgOut = imgIn;
    [row, col, depth] = size(imgIn);
    n = row * col;
    disp(size(imgIn));

    
    for i = 1:depth
        histEq = zeros(256,1);
        imgArr = imgIn(:,:,i);
        hist = image_histogram(imgArr);
        %disp(hist)
        %disp(hist(200));

        %figure,image_histogram(imgArr);

        for j = 1:256 
            sum = 0;
            for k = 1:j
                sum = sum + hist(k)/n;
            end
            histEq(j) = floor(sum*255);
        end

        for j = 1:row
            for k = 1:col
                %disp(imgIn(j,k,i));
                imgOut(j,k,i) = histEq(imgArr(j,k)+1);
            end
        end
        disp(max(imgArr(:)));
        disp(min(imgArr(:)));

        figure,bar(hist);
        figure,bar(histEq);
        figure,image_histogram(imgOut(:,:,i));
        figure,image_histogram(histeq(imgArr));

    end
end