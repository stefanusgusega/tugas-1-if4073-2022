function [specified_img_arr] = histogram_specification(source_img_arr,spec_img_arr)
%HISTOGRAM_SPECIFICATION Adjust the histogram of the source image based on specification image histogram
%   Detailed explanation goes here
% Should check the dimension?

% Extract histograms
source_img_hist = image_histogram(source_img_arr);
spec_img_hist = image_histogram(spec_img_arr);

% Switch case 1 channel (grayscale) or 3 channels (true color)
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