function [specified_img_arr] = histogram_specification(source_img_arr,spec_img_arr)
    %HISTOGRAM_SPECIFICATION Adjust the histogram of the source image based on specification image histogram
    %   Detailed explanation goes here
    % Should check the dimension?

    % Extract histograms
    source_img_hist = image_histogram(source_img_arr);
    spec_img_hist = image_histogram(spec_img_arr);

    % Get transformation array
    source_img_transformed_arr = transform(source_img_hist, numel(source_img_arr));
    spec_img_transformed_arr = transform(spec_img_hist, numel(spec_img_arr));

    final_transform = zeros(256, 1, 'uint8');

    % Based on source image transformation array, invert the transformation
    % Get distinct values of source image transformation array
    % distinct_vals_src = unique(source_img_transformed_arr);
    % distinct_vals_spec = unique(spec_img_transformed_arr);

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

    % Switch case 1 channel (grayscale) or 3 channels (true color) --> kayaknya ditaruh di UI nya aja

    % Example of switch case
    % Create histograms based on number of color channels
            % switch size(im,3)
            %     case 1
            %         % Display the grayscale image
            %         imagesc(app.ImageAxes,im);
                    
            %         % Plot all histograms with the same data for grayscale
            %         histr = histogram(app.RedAxes, im, 'FaceColor',[1 0 0],'EdgeColor', 'none');
            %         histg = histogram(app.GreenAxes, im, 'FaceColor',[0 1 0],'EdgeColor', 'none');
            %         histb = histogram(app.BlueAxes, im, 'FaceColor',[0 0 1],'EdgeColor', 'none');
                    
            %     case 3
            %         % Display the truecolor image
            %         imagesc(app.ImageAxes,im);
                    
            %         % Plot the histograms
            %         histr = histogram(app.RedAxes, im(:,:,1), 'FaceColor', [1 0 0], 'EdgeColor', 'none');
            %         histg = histogram(app.GreenAxes, im(:,:,2), 'FaceColor', [0 1 0], 'EdgeColor', 'none');
            %         histb = histogram(app.BlueAxes, im(:,:,3), 'FaceColor', [0 0 1], 'EdgeColor', 'none');
                    
            %     otherwise
            %         % Error when image is not grayscale or truecolor
            %         uialert(app.UIFigure, 'Image must be grayscale or truecolor.', 'Image Error');
            %         return;
            % end

end