function [specified_img_arr] = histogram_specification(source_img_arr,spec_img_arr)
    %HISTOGRAM_SPECIFICATION Adjust the histogram of the source image based on specification image histogram
    %   Detailed explanation goes here

    % Throw an exception
    if (~isequal(size(source_img_arr), size(spec_img_arr)))
        throw(MException('param:not-equal-dims', 'The dimension is not equal. Source image dimension : %s, Specified image dimension : %s', size(source_img_arr), size(spec_img_arr)))
    end

    % Extract histograms
    source_img_hist = image_histogram(source_img_arr);
    spec_img_hist = image_histogram(spec_img_arr);

    % Get transformation array
    source_img_transformed_arr = transform(source_img_hist, numel(source_img_arr));
    spec_img_transformed_arr = transform(spec_img_hist, numel(spec_img_arr));

    final_transform = zeros(256, 1, 'uint8');

    % Get the mapping
    for i = 1:256
        [val, idx] = min(abs(spec_img_transformed_arr - source_img_transformed_arr(i)));
        final_transform(i) = idx - 1; % Subtracted by 1 because the index is 1 - 256 and should be changed to image array value that is 0 - 255
    end


    % Transform the source image array based on final transform array
    [height, width] = size(source_img_arr);
    for j = 1:height
        for k = 1:width
            source_img_arr(j, k) = final_transform(source_img_arr(j, k) + 1); % Added by 1 because the image array value is 0 - 255
        end
    end

    specified_img_arr = source_img_arr;
end