%function [outputArg1,outputArg2] = imhist(inputArg1,inputArg2)
%IMHIST Summary of this function goes here
%   Detailed explanation goes here
%outputArg1 = inputArg1;
%outputArg2 = inputArg2;
%end

function arr = image_histogram(img_file_path)
%IMHIST Return an array of the distribution of an image that specified on img_file_path
%   And show the histogram of the distribution

img_arr = imread(img_file_path);
[height, width] = size(img_arr);

arr = zeros(256, 1);

for i = 1:height
    for j = 1:width
        arr_idx = img_arr(i,j) + 1;
        arr(arr_idx) = arr(arr_idx) + 1;
    end
end

bar(arr);

end

