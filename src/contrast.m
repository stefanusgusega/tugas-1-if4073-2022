function [imgOut] = contrast(fileName)
    imgIn = imread(fileName);

    rmin = min(imgIn(:));
    rmax = max(imgIn(:));
    
    % skip step set r<rmin -> 0, r>rmax -> 255
    % asumsi rmin = min(I) dan rmax = max(I)

    imgOut = (imgIn-rmin).*(255/(rmax-rmin)); 

    figure,imshow(imgIn);
    figure,image_histogram(imgIn);
    figure,imshow(imgOut);
    figure,image_histogram(imgOut);
end


    