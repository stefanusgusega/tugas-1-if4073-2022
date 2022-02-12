function [imgOut] = contrast(fileName)
    imgIn = imread(fileName);

    [row, col, depth] = size(imgIn);
    imgOut = imgIn;

    figure,imshow(imgIn);
    for i=1:depth
        imgArr = imgIn(:,:,i);
        rmin = min(imgArr(:));
        rmax = max(imgArr(:));
        
        % skip step set r<rmin -> 0, r>rmax -> 255
        % asumsi rmin = min(I) dan rmax = max(I)
        imgOut(:,:,i) = (imgArr-rmin).*(255/(rmax-rmin)); 
    
        figure,image_histogram(imgArr);
        figure,image_histogram(imgOut(:,:,i));
    end
    figure,imshow(imgOut);
end