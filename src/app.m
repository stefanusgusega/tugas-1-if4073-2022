classdef app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        TabGroup                    matlab.ui.container.TabGroup
        ContrastEnhancementTab      matlab.ui.container.Tab
        OutputImageLabel            matlab.ui.control.Label
        InputImageLabel             matlab.ui.control.Label
        SelectImageDropDown         matlab.ui.control.DropDown
        SelectImageDropDownLabel    matlab.ui.control.Label
        BlueAxes_Contrast_In_2      matlab.ui.control.UIAxes
        GreenAxes_Contrast_Out      matlab.ui.control.UIAxes
        RedAxes_Contrast_Out        matlab.ui.control.UIAxes
        BlueAxes_Contrast_In        matlab.ui.control.UIAxes
        ImageAxes_Contrast_Out      matlab.ui.control.UIAxes
        ImageAxes_Contrast_In       matlab.ui.control.UIAxes
        GreenAxes_Contrast_In       matlab.ui.control.UIAxes
        RedAxes_Contrast_In         matlab.ui.control.UIAxes
        HistogramEqualizationTab    matlab.ui.container.Tab
        LoadImageButton             matlab.ui.control.Button
        SelectImageDropDown_2       matlab.ui.control.DropDown
        SelectImageDropDown_2Label  matlab.ui.control.Label
        OutputImageLabel_2          matlab.ui.control.Label
        InputImageLabel_2           matlab.ui.control.Label
        ImageAxes_HistEq_In         matlab.ui.control.UIAxes
        BlueAxes_HistEq_Out         matlab.ui.control.UIAxes
        GreenAxes_HistEq_Out        matlab.ui.control.UIAxes
        RedAxes_HistEq_Out          matlab.ui.control.UIAxes
        BlueAxes_HistEq_In          matlab.ui.control.UIAxes
        ImageAxes_HistEq_Out        matlab.ui.control.UIAxes
        GreenAxes_HistEq_In         matlab.ui.control.UIAxes
        RedAxes_HistEq_In           matlab.ui.control.UIAxes
        HistogramSpecificationTab   matlab.ui.container.Tab
        TargetImageDropDown_2       matlab.ui.control.DropDown
        TargetImageDropDown_2Label  matlab.ui.control.Label
        SelectImageDropDown_3       matlab.ui.control.DropDown
        SelectImageDropDown_3Label  matlab.ui.control.Label
        OutputImageLabel_3          matlab.ui.control.Label
        InputImageLabel_3           matlab.ui.control.Label
        BlueAxes_HistSpec_Out       matlab.ui.control.UIAxes
        GreenAxes_HistSpec_Out      matlab.ui.control.UIAxes
        RedAxes_HistSpec_Out        matlab.ui.control.UIAxes
        BlueAxes_HistSpec_In        matlab.ui.control.UIAxes
        ImageAxes_HistSpec_Out      matlab.ui.control.UIAxes
        ImageAxes_HistSpec_In       matlab.ui.control.UIAxes
        GreenAxes_HistSpec_In       matlab.ui.control.UIAxes
        RedAxes_HistSpec_In         matlab.ui.control.UIAxes
        UIAxes19                    matlab.ui.control.UIAxes
    end

    
    methods (Access = private)
        function updateimage(app, fname, tab_num)
            try
                im = imread(fname);
            catch ME
                % if problem reading image, display error message
                uialert(app.UIFigure, ME.message, 'Image Error');
                return;
            end

            imageaxes_arr = [app.ImageAxes_Cont_In, app.ImageAxes_HistEq_In, app.ImageAxes_HistSpec_In];
            redaxes_arr = [app.RedAxes_Cont_In, app.RedAxes_HistEq_In, app.RedAxes_HistSpec_In];
            greenaxes_arr = [app.GreenAxes_Cont_In, app.GreenAxes_HistEq_In, app.GreenAxes_HistSpec_In];
            blueaxes_arr = [app.BlueAxes_Cont_In, app.BlueAxes_HistEq_In, app.BlueAxes_HistSpec_In];

            % assign current tab
            currImageAxes = imageaxes_arr(tab_num);
            currRedAxes = redaxes_arr(tab_num);
            currGreenAxes = greenaxes_arr(tab_num);
            currBlueAxes = blueaxes_arr(tab_num);

            % display the image
            imagesc(app.ImageAxes_HistEq_In, im);

            % create histograms based on number of color channel
            switch size(im,3)
                case 1
                    % Display the grayscale image
                    % imagesc(currImageAxes,im);
                    
                    % Plot all histograms with the same data for grayscale
                    histr = histogram(currRedAxes, im, 'FaceColor',[1 0 0],'EdgeColor', 'none');
                    histg = histogram(currGreenAxes, im, 'FaceColor',[0 1 0],'EdgeColor', 'none');
                    histb = histogram(currBlueAxes, im, 'FaceColor',[0 0 1],'EdgeColor', 'none');
                    
                case 3
                    % Display the truecolor image
                    % imagesc(currImageAxes,im);
                    
                    % Plot the histograms
                    histr = histogram(currRedAxes, im(:,:,1), 'FaceColor', [1 0 0], 'EdgeColor', 'none');
                    histg = histogram(currGreenAxes, im(:,:,2), 'FaceColor', [0 1 0], 'EdgeColor', 'none');
                    histb = histogram(currBlueAxes, im(:,:,3), 'FaceColor', [0 0 1], 'EdgeColor', 'none');
                    
                otherwise
                    % Error when image is not grayscale or truecolor
                    uialert(app.UIFigure, 'Image must be grayscale or truecolor.', 'Image Error');
                    return;
            end
                % Get largest bin count
                maxr = max(histr.BinCounts);
                maxg = max(histg.BinCounts);
                maxb = max(histb.BinCounts);
                maxcount = max([maxr maxg maxb]);
                
                % Set y axes limits based on largest bin count
                redaxes_arr(tab_num).YLim = [0 maxcount];
                redaxes_arr(tab_num).YTick = round([0 maxcount/2 maxcount], 2, 'significant');
                greenaxes_arr(tab_num).YLim = [0 maxcount];
                greenaxes_arr(tab_num).YTick = round([0 maxcount/2 maxcount], 2, 'significant');
                blueaxes_arr(tab_num).YLim = [0 maxcount];
                blueaxes_arr(tab_num).YTick = round([0 maxcount/2 maxcount], 2, 'significant');
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %% Contrast Enhancement

            %% Histogram Sepcification
            
            % Configure image axes
            app.ImageAxes_HistEq_In.Visible = 'off';
            app.ImageAxes_HistEq_In.Colormap = gray(256);
            axis(app.ImageAxes_HistEq_In, 'image');
            
            % Update the image and histograms
            updateimage(app, 'gorilla.tif', 2);

            %% Histogram Specification
        end

        % Callback function
        function LoadImageButtonPushed(app, event)
            % Display uigetfile dialog
            filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [f, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               fname = [p f];
               updateimage(app, fname);
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
            app.ImageAxes_Contrast_In.DataAspectRatio = [1 1 1];
            app.ImageAxes_Contrast_In.PlotBoxAspectRatio = [1.17615176151762 1 1];
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

            % Create BlueAxes_Contrast_In_2
            app.BlueAxes_Contrast_In_2 = uiaxes(app.ContrastEnhancementTab);
            title(app.BlueAxes_Contrast_In_2, 'Blue')
            xlabel(app.BlueAxes_Contrast_In_2, 'Intensity')
            ylabel(app.BlueAxes_Contrast_In_2, 'Pixels')
            zlabel(app.BlueAxes_Contrast_In_2, 'Z')
            app.BlueAxes_Contrast_In_2.XLim = [0 255];
            app.BlueAxes_Contrast_In_2.XTick = [0 128 255];
            app.BlueAxes_Contrast_In_2.XTickLabel = {'0'; '128'; '255'};
            app.BlueAxes_Contrast_In_2.Position = [664 59 182 121];

            % Create SelectImageDropDownLabel
            app.SelectImageDropDownLabel = uilabel(app.ContrastEnhancementTab);
            app.SelectImageDropDownLabel.HorizontalAlignment = 'right';
            app.SelectImageDropDownLabel.Position = [409 394 75 22];
            app.SelectImageDropDownLabel.Text = 'Select Image';

            % Create SelectImageDropDown
            app.SelectImageDropDown = uidropdown(app.ContrastEnhancementTab);
            app.SelectImageDropDown.Position = [489 388 89 33];

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
            app.ImageAxes_HistEq_In.DataAspectRatio = [1 1 1];
            app.ImageAxes_HistEq_In.PlotBoxAspectRatio = [1.17615176151762 1 1];
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

            % Create SelectImageDropDown_2Label
            app.SelectImageDropDown_2Label = uilabel(app.HistogramEqualizationTab);
            app.SelectImageDropDown_2Label.HorizontalAlignment = 'right';
            app.SelectImageDropDown_2Label.Position = [408 393 75 22];
            app.SelectImageDropDown_2Label.Text = 'Select Image';

            % Create SelectImageDropDown_2
            app.SelectImageDropDown_2 = uidropdown(app.HistogramEqualizationTab);
            app.SelectImageDropDown_2.Position = [488 387 89 33];

            % Create LoadImageButton
            app.LoadImageButton = uibutton(app.HistogramEqualizationTab, 'push');
            app.LoadImageButton.Position = [443 330 100 22];
            app.LoadImageButton.Text = 'Load Image';

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
            app.RedAxes_HistSpec_In.Position = [124 320 182 121];

            % Create GreenAxes_HistSpec_In
            app.GreenAxes_HistSpec_In = uiaxes(app.HistogramSpecificationTab);
            title(app.GreenAxes_HistSpec_In, 'Green')
            xlabel(app.GreenAxes_HistSpec_In, 'Intensity')
            ylabel(app.GreenAxes_HistSpec_In, 'Pixels')
            zlabel(app.GreenAxes_HistSpec_In, 'Z')
            app.GreenAxes_HistSpec_In.XLim = [0 255];
            app.GreenAxes_HistSpec_In.XTick = [0 128 255];
            app.GreenAxes_HistSpec_In.XTickLabel = {'0'; '128'; '255'};
            app.GreenAxes_HistSpec_In.Position = [124 192 182 121];

            % Create ImageAxes_HistSpec_In
            app.ImageAxes_HistSpec_In = uiaxes(app.HistogramSpecificationTab);
            app.ImageAxes_HistSpec_In.DataAspectRatio = [1 1 1];
            app.ImageAxes_HistSpec_In.PlotBoxAspectRatio = [1.17615176151762 1 1];
            app.ImageAxes_HistSpec_In.XTick = [];
            app.ImageAxes_HistSpec_In.YTick = [];
            app.ImageAxes_HistSpec_In.Position = [38 452 351 303];

            % Create ImageAxes_HistSpec_Out
            app.ImageAxes_HistSpec_Out = uiaxes(app.HistogramSpecificationTab);
            app.ImageAxes_HistSpec_Out.DataAspectRatio = [1 1 1];
            app.ImageAxes_HistSpec_Out.PlotBoxAspectRatio = [1.17615176151762 1 1];
            app.ImageAxes_HistSpec_Out.XTick = [];
            app.ImageAxes_HistSpec_Out.YTick = [];
            app.ImageAxes_HistSpec_Out.Position = [580 448 351 303];

            % Create BlueAxes_HistSpec_In
            app.BlueAxes_HistSpec_In = uiaxes(app.HistogramSpecificationTab);
            title(app.BlueAxes_HistSpec_In, 'Blue')
            xlabel(app.BlueAxes_HistSpec_In, 'Intensity')
            ylabel(app.BlueAxes_HistSpec_In, 'Pixels')
            zlabel(app.BlueAxes_HistSpec_In, 'Z')
            app.BlueAxes_HistSpec_In.XLim = [0 255];
            app.BlueAxes_HistSpec_In.XTick = [0 128 255];
            app.BlueAxes_HistSpec_In.XTickLabel = {'0'; '128'; '255'};
            app.BlueAxes_HistSpec_In.Position = [124 60 182 121];

            % Create RedAxes_HistSpec_Out
            app.RedAxes_HistSpec_Out = uiaxes(app.HistogramSpecificationTab);
            title(app.RedAxes_HistSpec_Out, 'Red')
            xlabel(app.RedAxes_HistSpec_Out, 'Intensity')
            ylabel(app.RedAxes_HistSpec_Out, 'Pixels')
            zlabel(app.RedAxes_HistSpec_Out, 'Z')
            app.RedAxes_HistSpec_Out.XLim = [0 255];
            app.RedAxes_HistSpec_Out.XTick = [0 128 255];
            app.RedAxes_HistSpec_Out.XTickLabel = {'0'; '128'; '255'};
            app.RedAxes_HistSpec_Out.Position = [664 320 182 121];

            % Create GreenAxes_HistSpec_Out
            app.GreenAxes_HistSpec_Out = uiaxes(app.HistogramSpecificationTab);
            title(app.GreenAxes_HistSpec_Out, 'Green')
            xlabel(app.GreenAxes_HistSpec_Out, 'Intensity')
            ylabel(app.GreenAxes_HistSpec_Out, 'Pixels')
            zlabel(app.GreenAxes_HistSpec_Out, 'Z')
            app.GreenAxes_HistSpec_Out.XLim = [0 255];
            app.GreenAxes_HistSpec_Out.XTick = [0 128 255];
            app.GreenAxes_HistSpec_Out.XTickLabel = {'0'; '128'; '255'};
            app.GreenAxes_HistSpec_Out.Position = [664 192 182 121];

            % Create BlueAxes_HistSpec_Out
            app.BlueAxes_HistSpec_Out = uiaxes(app.HistogramSpecificationTab);
            title(app.BlueAxes_HistSpec_Out, 'Blue')
            xlabel(app.BlueAxes_HistSpec_Out, 'Intensity')
            ylabel(app.BlueAxes_HistSpec_Out, 'Pixels')
            zlabel(app.BlueAxes_HistSpec_Out, 'Z')
            app.BlueAxes_HistSpec_Out.XLim = [0 255];
            app.BlueAxes_HistSpec_Out.XTick = [0 128 255];
            app.BlueAxes_HistSpec_Out.XTickLabel = {'0'; '128'; '255'};
            app.BlueAxes_HistSpec_Out.Position = [664 60 182 121];

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
            app.OutputImageLabel_3.Position = [611 745 108 22];
            app.OutputImageLabel_3.Text = 'Output Image';

            % Create SelectImageDropDown_3Label
            app.SelectImageDropDown_3Label = uilabel(app.HistogramSpecificationTab);
            app.SelectImageDropDown_3Label.HorizontalAlignment = 'right';
            app.SelectImageDropDown_3Label.Position = [408 393 75 22];
            app.SelectImageDropDown_3Label.Text = 'Select Image';

            % Create SelectImageDropDown_3
            app.SelectImageDropDown_3 = uidropdown(app.HistogramSpecificationTab);
            app.SelectImageDropDown_3.Position = [488 387 89 33];

            % Create TargetImageDropDown_2Label
            app.TargetImageDropDown_2Label = uilabel(app.HistogramSpecificationTab);
            app.TargetImageDropDown_2Label.HorizontalAlignment = 'right';
            app.TargetImageDropDown_2Label.Position = [410 325 75 22];
            app.TargetImageDropDown_2Label.Text = 'Target Image';

            % Create TargetImageDropDown_2
            app.TargetImageDropDown_2 = uidropdown(app.HistogramSpecificationTab);
            app.TargetImageDropDown_2.Position = [490 319 89 33];

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