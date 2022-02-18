classdef app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        TabGroup                     matlab.ui.container.TabGroup
        ContrastEnhancementTab       matlab.ui.container.Tab
        LoadImageButton_Contrast     matlab.ui.control.Button
        OutputImageLabel             matlab.ui.control.Label
        InputImageLabel              matlab.ui.control.Label
        BlueAxes_Contrast_Out        matlab.ui.control.UIAxes
        GreenAxes_Contrast_Out       matlab.ui.control.UIAxes
        RedAxes_Contrast_Out         matlab.ui.control.UIAxes
        BlueAxes_Contrast_In         matlab.ui.control.UIAxes
        ImageAxes_Contrast_Out       matlab.ui.control.UIAxes
        ImageAxes_Contrast_In        matlab.ui.control.UIAxes
        GreenAxes_Contrast_In        matlab.ui.control.UIAxes
        RedAxes_Contrast_In          matlab.ui.control.UIAxes
        HistogramEqualizationTab     matlab.ui.container.Tab
        LoadImageButton_HistEq       matlab.ui.control.Button
        OutputImageLabel_2           matlab.ui.control.Label
        InputImageLabel_2            matlab.ui.control.Label
        ImageAxes_HistEq_In          matlab.ui.control.UIAxes
        BlueAxes_HistEq_Out          matlab.ui.control.UIAxes
        GreenAxes_HistEq_Out         matlab.ui.control.UIAxes
        RedAxes_HistEq_Out           matlab.ui.control.UIAxes
        BlueAxes_HistEq_In           matlab.ui.control.UIAxes
        ImageAxes_HistEq_Out         matlab.ui.control.UIAxes
        GreenAxes_HistEq_In          matlab.ui.control.UIAxes
        RedAxes_HistEq_In            matlab.ui.control.UIAxes
        HistogramSpecificationTab    matlab.ui.container.Tab
        LoadImageButton_HistSpec_Target  matlab.ui.control.Button
        LoadImageButton_HistSpec_In  matlab.ui.control.Button
        TargetImageLabel             matlab.ui.control.Label
        OutputImageLabel_3           matlab.ui.control.Label
        InputImageLabel_3            matlab.ui.control.Label
        BlueAxes_HistSpec_Target     matlab.ui.control.UIAxes
        GreenAxes_HistSpec_Target    matlab.ui.control.UIAxes
        RedAxes_HistSpec_Target      matlab.ui.control.UIAxes
        ImageAxes_HistSpec_Target    matlab.ui.control.UIAxes
        BlueAxes_HistSpec_Out        matlab.ui.control.UIAxes
        GreenAxes_HistSpec_Out       matlab.ui.control.UIAxes
        RedAxes_HistSpec_Out         matlab.ui.control.UIAxes
        BlueAxes_HistSpec_In         matlab.ui.control.UIAxes
        ImageAxes_HistSpec_Out       matlab.ui.control.UIAxes
        ImageAxes_HistSpec_In        matlab.ui.control.UIAxes
        GreenAxes_HistSpec_In        matlab.ui.control.UIAxes
        RedAxes_HistSpec_In          matlab.ui.control.UIAxes
        UIAxes19                     matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        imageaxes_arr
        redaxes_arr
        greenaxes_arr
        blueaxes_arr
        outaxes_arr
        redoutaxes_arr
        greenoutaxes_arr
        blueoutaxes_arr
        
    end
    
    properties (Access = public)
        inputSpec;  % input file name for histogram specification
        targetSpec; % target file name for histogram specification
    end
    
    methods (Access = private)

        function updateImage(app, fname, tab_num)
            if strcmp(fname,'gorilla.tif')
                im = imread('gorilla.tif');
            else
                try
                    im = imread(fname);
                catch ME
                    % if problem reading image, display error message
                    uialert(app.UIFigure, ME.message, 'Image Error');
                    return;
                end
            end
            
            % assign current tab input
            currImageAxes = app.imageaxes_arr(tab_num);
            
            % assign current tab output
            currOutAxes = app.outaxes_arr(tab_num);    

            % display the image
            imagesc(currImageAxes, im);

            % create histograms based on number of color channel
            switch size(im,3)
                case 1
                    % Display the grayscale image
                    % imagesc(currImageAxes,im);
                   
                    % input hist
                    displayHist(app, im, tab_num, 1, 1);
               
                    % output hist
                    imgOut = getOutput(app, im, tab_num);
                    imagesc(currOutAxes, imgOut);
                    displayHist(app, imgOut, tab_num, 0, 1);

                case 3
                    % input hist
                    displayHist(app, im, tab_num, 1, 0);
                    
                    imgOut = im;
                    % output hist
                    imgOut(:,:,1) = getOutput(app, im(:,:,1), tab_num);
                    imgOut(:,:,2) = getOutput(app, im(:,:,2), tab_num);
                    imgOut(:,:,3) = getOutput(app, im(:,:,3), tab_num);

                    imagesc(currOutAxes, imgOut);
                    displayHist(app, imgOut, tab_num, 0, 0);
                    
                otherwise
                    % Error when image is not grayscale or truecolor
                    uialert(app.UIFigure, 'Image must be grayscale or truecolor.', 'Image Error');
                    return;
            end      
        end

        function updateSpecImage(app, fname, tname)
            try
                im = imread(fname);
                imTarget = imread(tname);
            catch ME
                % if problem reading image, display error message
                uialert(app.UIFigure, ME.message, 'Image Error');
                return;
            end

            % assign current tab input
            currImageAxes = app.imageaxes_arr(3);

            % assign current tab target
            currTargetAxes = app.ImageAxes_HistSpec_Target;

            % assign current tab output
            currOutAxes = app.outaxes_arr(3);    

            % display the image
            imagesc(currImageAxes, im);
            imagesc(currTargetAxes, imTarget);

            % create histograms based on number of color channel
            switch size(im,3)
                case 1
                    % Display the grayscale image
                    % imagesc(currImageAxes,im);
                   
                    % input hist
                    displayHist(app, im, 3, 1, 1);
                    
                    if size(imTarget,3)
                        % target hist
                        displayHist(app, imTarget, 3, -1, 0);
                        
                        imgOut = im;
                        % output hist
                        try 
                            imgOut(:,:,1) = histogram_specification(im, imTarget(:,:,1));
                            imgOut(:,:,2) = histogram_specification(im, imTarget(:,:,2));
                            imgOut(:,:,3) = histogram_specification(im, imTarget(:,:,3));
                        catch ME
                            uialert(app.UIFigure, ME.message, 'Inconvenient Size');
                            return;
                        end
                    else
                        % target hist
                        displayHist(app, imTarget, 3, -1, 1);

                        % output hist
                        try
                            imgOut = histogram_specification(im, imTarget);
                        catch ME
                            uialert(app.UIFigure, ME.message, 'Inconvenient Size');
                            return;
                        end
                    end
                    imagesc(currOutAxes, imgOut);
                    displayHist(app, imgOut, 3, 0, 1);

                case 3
                    % input hist
                    displayHist(app, im, 3, 1, 0);

                    % target hist
                    displayHist(app, imTarget, 3, -1, 0);
                    imgOut = im;

                    if size(imTarget,1)
                        % output hist
                        try
                            imgOut(:,:,1) = histogram_specification(im(:,:,1), imTarget);
                            imgOut(:,:,2) = histogram_specification(im(:,:,2), imTarget);
                            imgOut(:,:,3) = histogram_specification(im(:,:,3), imTarget);
                        catch ME
                            uialert(app.UIFigure, ME.message, 'Inconvenient Size');
                            return;
                        end
                    else
                        try
                            imgOut(:,:,1) = histogram_specification(im(:,:,1), imTarget(:,:,1));
                            imgOut(:,:,2) = histogram_specification(im(:,:,2), imTarget(:,:,2));
                            imgOut(:,:,3) = histogram_specification(im(:,:,3), imTarget(:,:,3));
                        catch ME
                            uialert(app.UIFigure, ME.message, 'Inconvenient Size');
                            return;
                        end    
                    end

                    imagesc(currOutAxes, imgOut);
                    displayHist(app, imgOut, 3, 0, 0);
                    
                otherwise
                    % Error when image is not grayscale or truecolor
                    uialert(app.UIFigure, 'Image must be grayscale or truecolor.', 'Image Error');
                    return;
            end      
        end

        % Function for getting output image
        function [imgOut] = getOutput(app, im, tab_num)
            switch (tab_num)
                case 1
                    imgOut = contrast(im);
                case 2
                    imgOut = histogram_equalization(im);
                otherwise
                    % Error when image is not grayscale or truecolor
                    uialert(app.UIFigure, 'Tab invalid.', 'Image Error');
                    return;
            end
        end
        
        % Function for displaying histogram
        function displayHist(app, img, tab_num, is_input, is_grayscale)
            % assign tab
            switch (is_input)
                % input
                case 1
                    % assign current tab input
                    currRedAxes = app.redaxes_arr(tab_num);
                    currGreenAxes = app.greenaxes_arr(tab_num);
                    currBlueAxes = app.blueaxes_arr(tab_num);
                % output
                case 0
                    % assign current tab output
                    currRedAxes = app.redoutaxes_arr(tab_num);
                    currGreenAxes = app.greenoutaxes_arr(tab_num);
                    currBlueAxes = app.blueoutaxes_arr(tab_num);
                % target
                case -1 
                    % assign current tab target
                    currRedAxes = app.RedAxes_HistSpec_Target;
                    currGreenAxes = app.GreenAxes_HistSpec_Target;
                    currBlueAxes = app.BlueAxes_HistSpec_Target;
                otherwise
                    % Error when image is not grayscale or truecolor
                    uialert(app.UIFigure, 'Variable invalid.', 'Image Error');
                    return;
            end

            % display histogram
            switch (is_grayscale)
                case 1
                    histr = image_histogram(img);
                    histg = image_histogram(img);
                    histb = image_histogram(img);
        
                    % Plot all histograms with the same data for grayscale
                    bar(currRedAxes, histr, 'FaceColor',[0.5 0.5 0.5],'EdgeColor', 'none');
                    bar(currGreenAxes, histg, 'FaceColor',[0.5 0.5 0.5],'EdgeColor', 'none');
                    bar(currBlueAxes, histb, 'FaceColor',[0.5 0.5 0.5],'EdgeColor', 'none');

                case 0
                    histr = image_histogram(img(:,:,1));
                    histg = image_histogram(img(:,:,2));
                    histb = image_histogram(img(:,:,3));

                    % Plot the histograms
                    bar(currRedAxes, histr, 'FaceColor', [1 0 0], 'EdgeColor', 'none');
                    bar(currGreenAxes, histg, 'FaceColor', [0 1 0], 'EdgeColor', 'none');
                    bar(currBlueAxes, histb, 'FaceColor', [0 0 1], 'EdgeColor', 'none');

                otherwise
                    % Error when image is not grayscale or truecolor
                    uialert(app.UIFigure, 'Image must be grayscale or truecolor.', 'Image Error');
                    return;
            end

            % Get largest bin count
            maxr = max(histr);
            maxg = max(histg);
            maxb = max(histb);
            maxcount = max([maxr maxg maxb]);
            
            % Set y axes limits based on largest bin count
            currRedAxes.YLim = [0 maxcount];
            currRedAxes.YTick = round([0 maxcount/2 maxcount], 2, 'significant');
            currGreenAxes.YLim = [0 maxcount];
            currGreenAxes.YTick = round([0 maxcount/2 maxcount], 2, 'significant');
            currBlueAxes.YLim = [0 maxcount];
            currBlueAxes.YTick = round([0 maxcount/2 maxcount], 2, 'significant');
        end

        function initiateImageAxesComponent(app, component)
            component.Visible = 'off';
            component.Colormap = gray(256);
            axis(component, 'image');
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.imageaxes_arr = [app.ImageAxes_Contrast_In, app.ImageAxes_HistEq_In, app.ImageAxes_HistSpec_In];
            app.redaxes_arr = [app.RedAxes_Contrast_In, app.RedAxes_HistEq_In, app.RedAxes_HistSpec_In];
            app.greenaxes_arr = [app.GreenAxes_Contrast_In, app.GreenAxes_HistEq_In, app.GreenAxes_HistSpec_In];
            app.blueaxes_arr = [app.BlueAxes_Contrast_In, app.BlueAxes_HistEq_In, app.BlueAxes_HistSpec_In];
        
            app.outaxes_arr = [app.ImageAxes_Contrast_Out, app.ImageAxes_HistEq_Out, app.ImageAxes_HistSpec_Out];
            app.redoutaxes_arr = [app.RedAxes_Contrast_Out, app.RedAxes_HistEq_Out, app.RedAxes_HistSpec_Out];
            app.greenoutaxes_arr = [app.GreenAxes_Contrast_Out, app.GreenAxes_HistEq_Out, app.GreenAxes_HistSpec_Out];
            app.blueoutaxes_arr = [app.BlueAxes_Contrast_Out, app.BlueAxes_HistEq_Out, app.BlueAxes_HistSpec_Out];
            
             % image path
            path = [pwd filesep '..' filesep 'images' filesep];

            %% Contrast Enhancement
            initiateImageAxesComponent(app, app.ImageAxes_Contrast_In);
            initiateImageAxesComponent(app, app.ImageAxes_Contrast_Out);
            
            updateImage(app, [path 'office_room.jpg'], 1);

            %% Histogram Equalization
            initiateImageAxesComponent(app, app.ImageAxes_HistEq_In);
            initiateImageAxesComponent(app, app.ImageAxes_HistEq_Out);

            updateImage(app, [path 'citra_acuan_2.jpg'], 2);

            %% Histogram Specification
            initiateImageAxesComponent(app, app.ImageAxes_HistSpec_In);
            initiateImageAxesComponent(app, app.ImageAxes_HistSpec_Target);
            initiateImageAxesComponent(app, app.ImageAxes_HistSpec_Out);

            app.inputSpec = [path 'bridge_1.jpg'];
            app.targetSpec = [path 'citra_acuan_2.jpg'];

            updateSpecImage(app, app.inputSpec, app.targetSpec);

        end

        % Button pushed function: LoadImageButton_HistEq
        function LoadImageButtonPushed(app, event)
            % Display uigetfile dialog
            filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [f, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               fname = [p f];
               updateImage(app, fname, 2);
            end
        end

        % Button pushed function: LoadImageButton_Contrast
        function LoadImageButton_ContrastPushed(app, event)
            % Display uigetfile dialog
            filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [f, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               fname = [p f];
               updateImage(app, fname, 1);
            end
        end

        % Button pushed function: LoadImageButton_HistSpec_Target
        function LoadImageButton_HistSpec_TargetPushed(app, event)
            % Display uigetfile dialog
            filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [f, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               fname = [p f];
               updateSpecImage(app, app.inputSpec, fname);
               app.targetSpec = fname;
            end
        end

        % Button pushed function: LoadImageButton_HistSpec_In
        function LoadImageButton_HistSpec_InPushed(app, event)
            % Display uigetfile dialog
            filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [f, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               fname = [p f];
               updateSpecImage(app, fname, app.targetSpec);
               app.inputSpec = fname;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 986 803];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes19
            app.UIAxes19 = uiaxes(app.UIFigure);
            title(app.UIAxes19, 'Title')
            xlabel(app.UIAxes19, 'X')
            ylabel(app.UIAxes19, 'Y')
            zlabel(app.UIAxes19, 'Z')
            app.UIAxes19.Position = [-513 1224 2 2];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 -4 987 808];

            % Create ContrastEnhancementTab
            app.ContrastEnhancementTab = uitab(app.TabGroup);
            app.ContrastEnhancementTab.Title = 'Contrast Enhancement';

            % Create RedAxes_Contrast_In
            app.RedAxes_Contrast_In = uiaxes(app.ContrastEnhancementTab);
            title(app.RedAxes_Contrast_In, 'Red')
            xlabel(app.RedAxes_Contrast_In, 'Intensity')
            ylabel(app.RedAxes_Contrast_In, 'Pixels')
            zlabel(app.RedAxes_Contrast_In, 'Z')
            app.RedAxes_Contrast_In.XLim = [0 255];
            app.RedAxes_Contrast_In.XTick = [0 128 255];
            app.RedAxes_Contrast_In.XTickLabel = {'0'; '128'; '255'};
            app.RedAxes_Contrast_In.Position = [124 320 182 121];

            % Create GreenAxes_Contrast_In
            app.GreenAxes_Contrast_In = uiaxes(app.ContrastEnhancementTab);
            title(app.GreenAxes_Contrast_In, 'Green')
            xlabel(app.GreenAxes_Contrast_In, 'Intensity')
            ylabel(app.GreenAxes_Contrast_In, 'Pixels')
            zlabel(app.GreenAxes_Contrast_In, 'Z')
            app.GreenAxes_Contrast_In.XLim = [0 255];
            app.GreenAxes_Contrast_In.XTick = [0 128 255];
            app.GreenAxes_Contrast_In.XTickLabel = {'0'; '128'; '255'};
            app.GreenAxes_Contrast_In.Position = [124 192 182 121];

            % Create ImageAxes_Contrast_In
            app.ImageAxes_Contrast_In = uiaxes(app.ContrastEnhancementTab);
            app.ImageAxes_Contrast_In.XTick = [];
            app.ImageAxes_Contrast_In.YTick = [];
            app.ImageAxes_Contrast_In.Position = [38 452 351 303];

            % Create ImageAxes_Contrast_Out
            app.ImageAxes_Contrast_Out = uiaxes(app.ContrastEnhancementTab);
            app.ImageAxes_Contrast_Out.DataAspectRatio = [1 1 1];
            app.ImageAxes_Contrast_Out.PlotBoxAspectRatio = [1.17615176151762 1 1];
            app.ImageAxes_Contrast_Out.XTick = [];
            app.ImageAxes_Contrast_Out.YTick = [];
            app.ImageAxes_Contrast_Out.Position = [584 448 351 303];

            % Create BlueAxes_Contrast_In
            app.BlueAxes_Contrast_In = uiaxes(app.ContrastEnhancementTab);
            title(app.BlueAxes_Contrast_In, 'Blue')
            xlabel(app.BlueAxes_Contrast_In, 'Intensity')
            ylabel(app.BlueAxes_Contrast_In, 'Pixels')
            zlabel(app.BlueAxes_Contrast_In, 'Z')
            app.BlueAxes_Contrast_In.XLim = [0 255];
            app.BlueAxes_Contrast_In.XTick = [0 128 255];
            app.BlueAxes_Contrast_In.XTickLabel = {'0'; '128'; '255'};
            app.BlueAxes_Contrast_In.Position = [124 60 182 121];

            % Create RedAxes_Contrast_Out
            app.RedAxes_Contrast_Out = uiaxes(app.ContrastEnhancementTab);
            title(app.RedAxes_Contrast_Out, 'Red')
            xlabel(app.RedAxes_Contrast_Out, 'Intensity')
            ylabel(app.RedAxes_Contrast_Out, 'Pixels')
            zlabel(app.RedAxes_Contrast_Out, 'Z')
            app.RedAxes_Contrast_Out.XLim = [0 255];
            app.RedAxes_Contrast_Out.XTick = [0 128 255];
            app.RedAxes_Contrast_Out.XTickLabel = {'0'; '128'; '255'};
            app.RedAxes_Contrast_Out.Position = [664 320 182 121];

            % Create GreenAxes_Contrast_Out
            app.GreenAxes_Contrast_Out = uiaxes(app.ContrastEnhancementTab);
            title(app.GreenAxes_Contrast_Out, 'Green')
            xlabel(app.GreenAxes_Contrast_Out, 'Intensity')
            ylabel(app.GreenAxes_Contrast_Out, 'Pixels')
            zlabel(app.GreenAxes_Contrast_Out, 'Z')
            app.GreenAxes_Contrast_Out.XLim = [0 255];
            app.GreenAxes_Contrast_Out.XTick = [0 128 255];
            app.GreenAxes_Contrast_Out.XTickLabel = {'0'; '128'; '255'};
            app.GreenAxes_Contrast_Out.Position = [664 192 182 121];

            % Create BlueAxes_Contrast_Out
            app.BlueAxes_Contrast_Out = uiaxes(app.ContrastEnhancementTab);
            title(app.BlueAxes_Contrast_Out, 'Blue')
            xlabel(app.BlueAxes_Contrast_Out, 'Intensity')
            ylabel(app.BlueAxes_Contrast_Out, 'Pixels')
            zlabel(app.BlueAxes_Contrast_Out, 'Z')
            app.BlueAxes_Contrast_Out.XLim = [0 255];
            app.BlueAxes_Contrast_Out.XTick = [0 128 255];
            app.BlueAxes_Contrast_Out.XTickLabel = {'0'; '128'; '255'};
            app.BlueAxes_Contrast_Out.Position = [664 59 182 121];

            % Create InputImageLabel
            app.InputImageLabel = uilabel(app.ContrastEnhancementTab);
            app.InputImageLabel.FontSize = 16;
            app.InputImageLabel.FontWeight = 'bold';
            app.InputImageLabel.Position = [70 747 95 22];
            app.InputImageLabel.Text = 'Input Image';

            % Create OutputImageLabel
            app.OutputImageLabel = uilabel(app.ContrastEnhancementTab);
            app.OutputImageLabel.FontSize = 16;
            app.OutputImageLabel.FontWeight = 'bold';
            app.OutputImageLabel.Position = [614 747 108 22];
            app.OutputImageLabel.Text = 'Output Image';

            % Create LoadImageButton_Contrast
            app.LoadImageButton_Contrast = uibutton(app.ContrastEnhancementTab, 'push');
            app.LoadImageButton_Contrast.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButton_ContrastPushed, true);
            app.LoadImageButton_Contrast.Position = [438 394 100 22];
            app.LoadImageButton_Contrast.Text = 'Load Image';

            % Create HistogramEqualizationTab
            app.HistogramEqualizationTab = uitab(app.TabGroup);
            app.HistogramEqualizationTab.Title = 'Histogram Equalization';

            % Create RedAxes_HistEq_In
            app.RedAxes_HistEq_In = uiaxes(app.HistogramEqualizationTab);
            title(app.RedAxes_HistEq_In, 'Red')
            xlabel(app.RedAxes_HistEq_In, 'Intensity')
            ylabel(app.RedAxes_HistEq_In, 'Pixels')
            zlabel(app.RedAxes_HistEq_In, 'Z')
            app.RedAxes_HistEq_In.XLim = [0 255];
            app.RedAxes_HistEq_In.XTick = [0 128 255];
            app.RedAxes_HistEq_In.XTickLabel = {'0'; '128'; '255'};
            app.RedAxes_HistEq_In.Position = [124 320 182 121];

            % Create GreenAxes_HistEq_In
            app.GreenAxes_HistEq_In = uiaxes(app.HistogramEqualizationTab);
            title(app.GreenAxes_HistEq_In, 'Green')
            xlabel(app.GreenAxes_HistEq_In, 'Intensity')
            ylabel(app.GreenAxes_HistEq_In, 'Pixels')
            zlabel(app.GreenAxes_HistEq_In, 'Z')
            app.GreenAxes_HistEq_In.XLim = [0 255];
            app.GreenAxes_HistEq_In.XTick = [0 128 255];
            app.GreenAxes_HistEq_In.XTickLabel = {'0'; '128'; '255'};
            app.GreenAxes_HistEq_In.Position = [124 192 182 121];

            % Create ImageAxes_HistEq_Out
            app.ImageAxes_HistEq_Out = uiaxes(app.HistogramEqualizationTab);
            app.ImageAxes_HistEq_Out.DataAspectRatio = [1 1 1];
            app.ImageAxes_HistEq_Out.PlotBoxAspectRatio = [1.17615176151762 1 1];
            app.ImageAxes_HistEq_Out.XTick = [];
            app.ImageAxes_HistEq_Out.YTick = [];
            app.ImageAxes_HistEq_Out.Position = [580 448 351 303];

            % Create BlueAxes_HistEq_In
            app.BlueAxes_HistEq_In = uiaxes(app.HistogramEqualizationTab);
            title(app.BlueAxes_HistEq_In, 'Blue')
            xlabel(app.BlueAxes_HistEq_In, 'Intensity')
            ylabel(app.BlueAxes_HistEq_In, 'Pixels')
            zlabel(app.BlueAxes_HistEq_In, 'Z')
            app.BlueAxes_HistEq_In.XLim = [0 255];
            app.BlueAxes_HistEq_In.XTick = [0 128 255];
            app.BlueAxes_HistEq_In.XTickLabel = {'0'; '128'; '255'};
            app.BlueAxes_HistEq_In.Position = [124 60 182 121];

            % Create RedAxes_HistEq_Out
            app.RedAxes_HistEq_Out = uiaxes(app.HistogramEqualizationTab);
            title(app.RedAxes_HistEq_Out, 'Red')
            xlabel(app.RedAxes_HistEq_Out, 'Intensity')
            ylabel(app.RedAxes_HistEq_Out, 'Pixels')
            zlabel(app.RedAxes_HistEq_Out, 'Z')
            app.RedAxes_HistEq_Out.XLim = [0 255];
            app.RedAxes_HistEq_Out.XTick = [0 128 255];
            app.RedAxes_HistEq_Out.XTickLabel = {'0'; '128'; '255'};
            app.RedAxes_HistEq_Out.Position = [664 320 182 121];

            % Create GreenAxes_HistEq_Out
            app.GreenAxes_HistEq_Out = uiaxes(app.HistogramEqualizationTab);
            title(app.GreenAxes_HistEq_Out, 'Green')
            xlabel(app.GreenAxes_HistEq_Out, 'Intensity')
            ylabel(app.GreenAxes_HistEq_Out, 'Pixels')
            zlabel(app.GreenAxes_HistEq_Out, 'Z')
            app.GreenAxes_HistEq_Out.XLim = [0 255];
            app.GreenAxes_HistEq_Out.XTick = [0 128 255];
            app.GreenAxes_HistEq_Out.XTickLabel = {'0'; '128'; '255'};
            app.GreenAxes_HistEq_Out.Position = [664 192 182 121];

            % Create BlueAxes_HistEq_Out
            app.BlueAxes_HistEq_Out = uiaxes(app.HistogramEqualizationTab);
            title(app.BlueAxes_HistEq_Out, 'Blue')
            xlabel(app.BlueAxes_HistEq_Out, 'Intensity')
            ylabel(app.BlueAxes_HistEq_Out, 'Pixels')
            zlabel(app.BlueAxes_HistEq_Out, 'Z')
            app.BlueAxes_HistEq_Out.XLim = [0 255];
            app.BlueAxes_HistEq_Out.XTick = [0 128 255];
            app.BlueAxes_HistEq_Out.XTickLabel = {'0'; '128'; '255'};
            app.BlueAxes_HistEq_Out.Position = [664 60 182 121];

            % Create ImageAxes_HistEq_In
            app.ImageAxes_HistEq_In = uiaxes(app.HistogramEqualizationTab);
            app.ImageAxes_HistEq_In.XTick = [];
            app.ImageAxes_HistEq_In.YTick = [];
            app.ImageAxes_HistEq_In.Position = [38 452 351 303];

            % Create InputImageLabel_2
            app.InputImageLabel_2 = uilabel(app.HistogramEqualizationTab);
            app.InputImageLabel_2.FontSize = 16;
            app.InputImageLabel_2.FontWeight = 'bold';
            app.InputImageLabel_2.Position = [70 747 95 22];
            app.InputImageLabel_2.Text = 'Input Image';

            % Create OutputImageLabel_2
            app.OutputImageLabel_2 = uilabel(app.HistogramEqualizationTab);
            app.OutputImageLabel_2.FontSize = 16;
            app.OutputImageLabel_2.FontWeight = 'bold';
            app.OutputImageLabel_2.Position = [611 745 108 22];
            app.OutputImageLabel_2.Text = 'Output Image';

            % Create LoadImageButton_HistEq
            app.LoadImageButton_HistEq = uibutton(app.HistogramEqualizationTab, 'push');
            app.LoadImageButton_HistEq.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButtonPushed, true);
            app.LoadImageButton_HistEq.Position = [438 393 100 22];
            app.LoadImageButton_HistEq.Text = 'Load Image';

            % Create HistogramSpecificationTab
            app.HistogramSpecificationTab = uitab(app.TabGroup);
            app.HistogramSpecificationTab.Title = 'Histogram Specification';

            % Create RedAxes_HistSpec_In
            app.RedAxes_HistSpec_In = uiaxes(app.HistogramSpecificationTab);
            title(app.RedAxes_HistSpec_In, 'Red')
            xlabel(app.RedAxes_HistSpec_In, 'Intensity')
            ylabel(app.RedAxes_HistSpec_In, 'Pixels')
            zlabel(app.RedAxes_HistSpec_In, 'Z')
            app.RedAxes_HistSpec_In.XLim = [0 255];
            app.RedAxes_HistSpec_In.YLim = [0 1];
            app.RedAxes_HistSpec_In.ZLim = [0 255];
            app.RedAxes_HistSpec_In.XTick = [0 128 255];
            app.RedAxes_HistSpec_In.XTickLabel = {'0'; '128'; '255'};
            app.RedAxes_HistSpec_In.Position = [97 322 182 121];

            % Create GreenAxes_HistSpec_In
            app.GreenAxes_HistSpec_In = uiaxes(app.HistogramSpecificationTab);
            title(app.GreenAxes_HistSpec_In, 'Green')
            xlabel(app.GreenAxes_HistSpec_In, 'Intensity')
            ylabel(app.GreenAxes_HistSpec_In, 'Pixels')
            zlabel(app.GreenAxes_HistSpec_In, 'Z')
            app.GreenAxes_HistSpec_In.XLim = [0 255];
            app.GreenAxes_HistSpec_In.XTick = [0 128 255];
            app.GreenAxes_HistSpec_In.XTickLabel = {'0'; '128'; '255'};
            app.GreenAxes_HistSpec_In.Position = [97 194 182 121];

            % Create ImageAxes_HistSpec_In
            app.ImageAxes_HistSpec_In = uiaxes(app.HistogramSpecificationTab);
            app.ImageAxes_HistSpec_In.XTick = [];
            app.ImageAxes_HistSpec_In.YTick = [];
            app.ImageAxes_HistSpec_In.Position = [38 495 297 256];

            % Create ImageAxes_HistSpec_Out
            app.ImageAxes_HistSpec_Out = uiaxes(app.HistogramSpecificationTab);
            app.ImageAxes_HistSpec_Out.DataAspectRatio = [1 1 1];
            app.ImageAxes_HistSpec_Out.PlotBoxAspectRatio = [1.17615176151762 1 1];
            app.ImageAxes_HistSpec_Out.XTick = [];
            app.ImageAxes_HistSpec_Out.YTick = [];
            app.ImageAxes_HistSpec_Out.Position = [639 495 297 256];

            % Create BlueAxes_HistSpec_In
            app.BlueAxes_HistSpec_In = uiaxes(app.HistogramSpecificationTab);
            title(app.BlueAxes_HistSpec_In, 'Blue')
            xlabel(app.BlueAxes_HistSpec_In, 'Intensity')
            ylabel(app.BlueAxes_HistSpec_In, 'Pixels')
            zlabel(app.BlueAxes_HistSpec_In, 'Z')
            app.BlueAxes_HistSpec_In.XLim = [0 255];
            app.BlueAxes_HistSpec_In.XTick = [0 128 255];
            app.BlueAxes_HistSpec_In.XTickLabel = {'0'; '128'; '255'};
            app.BlueAxes_HistSpec_In.Position = [97 62 182 121];

            % Create RedAxes_HistSpec_Out
            app.RedAxes_HistSpec_Out = uiaxes(app.HistogramSpecificationTab);
            title(app.RedAxes_HistSpec_Out, 'Red')
            xlabel(app.RedAxes_HistSpec_Out, 'Intensity')
            ylabel(app.RedAxes_HistSpec_Out, 'Pixels')
            zlabel(app.RedAxes_HistSpec_Out, 'Z')
            app.RedAxes_HistSpec_Out.XLim = [0 255];
            app.RedAxes_HistSpec_Out.XTick = [0 128 255];
            app.RedAxes_HistSpec_Out.XTickLabel = {'0'; '128'; '255'};
            app.RedAxes_HistSpec_Out.Position = [696 322 182 121];

            % Create GreenAxes_HistSpec_Out
            app.GreenAxes_HistSpec_Out = uiaxes(app.HistogramSpecificationTab);
            title(app.GreenAxes_HistSpec_Out, 'Green')
            xlabel(app.GreenAxes_HistSpec_Out, 'Intensity')
            ylabel(app.GreenAxes_HistSpec_Out, 'Pixels')
            zlabel(app.GreenAxes_HistSpec_Out, 'Z')
            app.GreenAxes_HistSpec_Out.XLim = [0 255];
            app.GreenAxes_HistSpec_Out.XTick = [0 128 255];
            app.GreenAxes_HistSpec_Out.XTickLabel = {'0'; '128'; '255'};
            app.GreenAxes_HistSpec_Out.Position = [696 194 182 121];

            % Create BlueAxes_HistSpec_Out
            app.BlueAxes_HistSpec_Out = uiaxes(app.HistogramSpecificationTab);
            title(app.BlueAxes_HistSpec_Out, 'Blue')
            xlabel(app.BlueAxes_HistSpec_Out, 'Intensity')
            ylabel(app.BlueAxes_HistSpec_Out, 'Pixels')
            zlabel(app.BlueAxes_HistSpec_Out, 'Z')
            app.BlueAxes_HistSpec_Out.XLim = [0 255];
            app.BlueAxes_HistSpec_Out.XTick = [0 128 255];
            app.BlueAxes_HistSpec_Out.XTickLabel = {'0'; '128'; '255'};
            app.BlueAxes_HistSpec_Out.Position = [696 62 182 121];

            % Create ImageAxes_HistSpec_Target
            app.ImageAxes_HistSpec_Target = uiaxes(app.HistogramSpecificationTab);
            app.ImageAxes_HistSpec_Target.DataAspectRatio = [1 1 1];
            app.ImageAxes_HistSpec_Target.PlotBoxAspectRatio = [1.17615176151762 1 1];
            app.ImageAxes_HistSpec_Target.XTick = [];
            app.ImageAxes_HistSpec_Target.YTick = [];
            app.ImageAxes_HistSpec_Target.Position = [339 495 297 256];

            % Create RedAxes_HistSpec_Target
            app.RedAxes_HistSpec_Target = uiaxes(app.HistogramSpecificationTab);
            title(app.RedAxes_HistSpec_Target, 'Red')
            xlabel(app.RedAxes_HistSpec_Target, 'Intensity')
            ylabel(app.RedAxes_HistSpec_Target, 'Pixels')
            zlabel(app.RedAxes_HistSpec_Target, 'Z')
            app.RedAxes_HistSpec_Target.XLim = [0 255];
            app.RedAxes_HistSpec_Target.YLim = [0 1];
            app.RedAxes_HistSpec_Target.ZLim = [0 255];
            app.RedAxes_HistSpec_Target.XTick = [0 128 255];
            app.RedAxes_HistSpec_Target.XTickLabel = {'0'; '128'; '255'};
            app.RedAxes_HistSpec_Target.Position = [400 322 182 121];

            % Create GreenAxes_HistSpec_Target
            app.GreenAxes_HistSpec_Target = uiaxes(app.HistogramSpecificationTab);
            title(app.GreenAxes_HistSpec_Target, 'Green')
            xlabel(app.GreenAxes_HistSpec_Target, 'Intensity')
            ylabel(app.GreenAxes_HistSpec_Target, 'Pixels')
            zlabel(app.GreenAxes_HistSpec_Target, 'Z')
            app.GreenAxes_HistSpec_Target.XLim = [0 255];
            app.GreenAxes_HistSpec_Target.XTick = [0 128 255];
            app.GreenAxes_HistSpec_Target.XTickLabel = {'0'; '128'; '255'};
            app.GreenAxes_HistSpec_Target.Position = [400 194 182 121];

            % Create BlueAxes_HistSpec_Target
            app.BlueAxes_HistSpec_Target = uiaxes(app.HistogramSpecificationTab);
            title(app.BlueAxes_HistSpec_Target, 'Blue')
            xlabel(app.BlueAxes_HistSpec_Target, 'Intensity')
            ylabel(app.BlueAxes_HistSpec_Target, 'Pixels')
            zlabel(app.BlueAxes_HistSpec_Target, 'Z')
            app.BlueAxes_HistSpec_Target.XLim = [0 255];
            app.BlueAxes_HistSpec_Target.XTick = [0 128 255];
            app.BlueAxes_HistSpec_Target.XTickLabel = {'0'; '128'; '255'};
            app.BlueAxes_HistSpec_Target.Position = [400 62 182 121];

            % Create InputImageLabel_3
            app.InputImageLabel_3 = uilabel(app.HistogramSpecificationTab);
            app.InputImageLabel_3.FontSize = 16;
            app.InputImageLabel_3.FontWeight = 'bold';
            app.InputImageLabel_3.Position = [70 747 95 22];
            app.InputImageLabel_3.Text = 'Input Image';

            % Create OutputImageLabel_3
            app.OutputImageLabel_3 = uilabel(app.HistogramSpecificationTab);
            app.OutputImageLabel_3.FontSize = 16;
            app.OutputImageLabel_3.FontWeight = 'bold';
            app.OutputImageLabel_3.Position = [665 749 108 22];
            app.OutputImageLabel_3.Text = 'Output Image';

            % Create TargetImageLabel
            app.TargetImageLabel = uilabel(app.HistogramSpecificationTab);
            app.TargetImageLabel.FontSize = 16;
            app.TargetImageLabel.FontWeight = 'bold';
            app.TargetImageLabel.Position = [367 748 103 22];
            app.TargetImageLabel.Text = 'Target Image';

            % Create LoadImageButton_HistSpec_In
            app.LoadImageButton_HistSpec_In = uibutton(app.HistogramSpecificationTab, 'push');
            app.LoadImageButton_HistSpec_In.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButton_HistSpec_InPushed, true);
            app.LoadImageButton_HistSpec_In.Position = [138 474 100 22];
            app.LoadImageButton_HistSpec_In.Text = 'Load Image';

            % Create LoadImageButton_HistSpec_Target
            app.LoadImageButton_HistSpec_Target = uibutton(app.HistogramSpecificationTab, 'push');
            app.LoadImageButton_HistSpec_Target.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButton_HistSpec_TargetPushed, true);
            app.LoadImageButton_HistSpec_Target.Position = [451 474 100 22];
            app.LoadImageButton_HistSpec_Target.Text = 'Load Image';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end