function [imgOut] = contrast(imgIn)
    % rmin & rmax
    rmin = min(imgIn(:));
    rmax = max(imgIn(:));
    
    % skip step set r<rmin -> 0, r>rmax -> 255
    % asumsi rmin = min(I) dan rmax = max(I)

    % transform image
    imgOut = (imgIn-rmin).*(255/(rmax-rmin)); 
end