function [imgOut] = contrast(fileName)
    imgIn = imread(fileName);

    rmin = min(imgIn(:));
    rmax = max(imgIn(:));
    
    % step: set r<rmin -> 0, r>rmax -> 255
    % asumsi rmin = min(I) dan rmax = max(I)

    imgOut = (imgIn-rmin).*(255/(rmax-rmin)); % for all pixels

    figure,imshow(imgIn);
    figure,imhist(imgIn);
    figure,imshow(imgOut);
    figure,imhist(imgOut);
end

% to do: ganti imhist -> image_histogram

    