function [imgOut] = contrast(fileName)

    % read image
    imgIn = imread(fileName);

    % image size
    [row, col, depth] = size(imgIn);

    % output initialization
    imgOut = imgIn;

    % show input image
    figure,imshow(imgIn);

    % for each color
    for i=1:depth
        imgArr = imgIn(:,:,i);

        % rmin & rmax
        rmin = min(imgArr(:));
        rmax = max(imgArr(:));
        
        % skip step set r<rmin -> 0, r>rmax -> 255
        % asumsi rmin = min(I) dan rmax = max(I)

        % transform image
        imgOut(:,:,i) = (imgArr-rmin).*(255/(rmax-rmin)); 
    
        % show histogram
        figure,image_histogram(imgArr);
        figure,image_histogram(imgOut(:,:,i));
    end

    % show output color
    figure,imshow(imgOut);
end