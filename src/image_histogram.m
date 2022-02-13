function arr = image_histogram(img_arr)
    %IMHIST Return an array of the distribution of an image that specified on img_file_path
    %   And show the histogram of the distribution using bar plot
    %   imread should be performed on GUI to be passed onto this function

    [height, width] = size(img_arr);
    arr = zeros(256, 1, 'uint8');

    for i = 1:height
        for j = 1:width
            % Should be added 1 because MATLAB indexing starts from 1
            arr_idx = img_arr(i,j) + 1;
            arr(arr_idx) = arr(arr_idx) + 1;
        end
    end

    bar(arr);

end

