function [imgOut] = contrast(imgIn)

    % read image
    %imgIn = imread(fileName);

    % image size
    % [row, col, depth] = size(imgIn);

    % output initialization
    % imgOut = imgIn;

    % show input image
    figure,imshow(imgIn);

    % for each color
    % for i=1:depth
    %imgArr = imgIn(:,:,i);

    % rmin & rmax
    rmin = min(imgIn(:));
    rmax = max(imgIn(:));
    
    % skip step set r<rmin -> 0, r>rmax -> 255
    % asumsi rmin = min(I) dan rmax = max(I)

    % transform image
    imgOut = (imgIn-rmin).*(255/(rmax-rmin)); 

    % show histogram
    %figure,image_histogram(imgIn);
    %figure,image_histogram(imgOut);
    %end

    % show output color
    %figure,imshow(imgOut);
end