classdef GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        GrayscaleMenu          matlab.ui.container.Menu
        RGBMenu                matlab.ui.container.Menu
        PredefinedImagesLabel  matlab.ui.control.Label
        DropDown               matlab.ui.control.DropDown
        LoadButton             matlab.ui.control.Button
        RedAxes                matlab.ui.control.UIAxes
        BlueAxes               matlab.ui.control.UIAxes
        GreenAxes              matlab.ui.control.UIAxes
        ImageAxes              matlab.ui.control.UIAxes
    end

    
    methods (Access = private)
        
        function updateimage(app,imagefile)
            
            % For corn.tif, read the second image in the file
            if strcmp(imagefile,'corn.tif')
                im = imread('corn.tif', 2);
            else
                try
                    im = imread(imagefile);
                catch ME
                    % If problem reading image, display error message
                    uialert(app.UIFigure, ME.message, 'Image Error');
                    return;
                end            
            end 
            
            % Create histograms based on number of color channels
            switch size(im,3)
                case 1
                    % Display the grayscale image
                    imagesc(app.ImageAxes,im);
                    
                    % Plot all histograms with the same data for grayscale
                    histr = histogram(app.RedAxes, im, 'FaceColor',[1 0 0],'EdgeColor', 'none');
                    histg = histogram(app.GreenAxes, im, 'FaceColor',[0 1 0],'EdgeColor', 'none');
                    histb = histogram(app.BlueAxes, im, 'FaceColor',[0 0 1],'EdgeColor', 'none');
                    
                case 3
                    % Display the truecolor image
                    imagesc(app.ImageAxes,im);
                    
                    % Plot the histograms
                    histr = histogram(app.RedAxes, im(:,:,1), 'FaceColor', [1 0 0], 'EdgeColor', 'none');
                    histg = histogram(app.GreenAxes, im(:,:,2), 'FaceColor', [0 1 0], 'EdgeColor', 'none');
                    histb = histogram(app.BlueAxes, im(:,:,3), 'FaceColor', [0 0 1], 'EdgeColor', 'none');
                    
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
                app.RedAxes.YLim = [0 maxcount];
                app.RedAxes.YTick = round([0 maxcount/2 maxcount], 2, 'significant');
                app.GreenAxes.YLim = [0 maxcount];
                app.GreenAxes.YTick = round([0 maxcount/2 maxcount], 2, 'significant');
                app.BlueAxes.YLim = [0 maxcount];
                app.BlueAxes.YTick = round([0 maxcount/2 maxcount], 2, 'significant');
         
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Configure image axes
            app.ImageAxes.Visible = 'off';
            app.ImageAxes.Colormap = gray(256);
            axis(app.ImageAxes, 'image');
            
            % Update the image and histograms
            updateimage(app, 'peppers.png');
        end

        % Value changed function: DropDown
        function DropDownValueChanged(app, event)
            
            % Update the image and histograms
            updateimage(app, app.DropDown.Value);
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
               
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
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 702 528];
            app.UIFigure.Name = 'Image Histograms';
            app.UIFigure.Resize = 'off';

            % Create GrayscaleMenu
            app.GrayscaleMenu = uimenu(app.UIFigure);
            app.GrayscaleMenu.Text = 'Grayscale';

            % Create RGBMenu
            app.RGBMenu = uimenu(app.UIFigure);
            app.RGBMenu.Text = 'RGB';

            % Create ImageAxes
            app.ImageAxes = uiaxes(app.UIFigure);
            app.ImageAxes.XTick = [];
            app.ImageAxes.XTickLabel = {'[ ]'};
            app.ImageAxes.YTick = [];
            app.ImageAxes.Position = [43 181 357 305];

            % Create GreenAxes
            app.GreenAxes = uiaxes(app.UIFigure);
            title(app.GreenAxes, 'Green')
            xlabel(app.GreenAxes, 'Intensity')
            ylabel(app.GreenAxes, 'Pixels')
            app.GreenAxes.XLim = [0 255];
            app.GreenAxes.XTick = [0 128 255];
            app.GreenAxes.Position = [437 191 236 152];

            % Create BlueAxes
            app.BlueAxes = uiaxes(app.UIFigure);
            title(app.BlueAxes, 'Blue')
            xlabel(app.BlueAxes, 'Intensity')
            ylabel(app.BlueAxes, 'Pixels')
            app.BlueAxes.XLim = [0 255];
            app.BlueAxes.XTick = [0 128 255];
            app.BlueAxes.Position = [437 19 236 152];

            % Create RedAxes
            app.RedAxes = uiaxes(app.UIFigure);
            title(app.RedAxes, 'Red')
            xlabel(app.RedAxes, 'Intensity')
            ylabel(app.RedAxes, 'Pixels')
            app.RedAxes.XLim = [0 255];
            app.RedAxes.XTick = [0 128 255];
            app.RedAxes.Position = [437 363 236 152];

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [109 80 225 22];
            app.LoadButton.Text = 'Load Custom Image';

            % Create DropDown
            app.DropDown = uidropdown(app.UIFigure);
            app.DropDown.Items = {'Peppers', 'Corn'};
            app.DropDown.ItemsData = {'peppers.png', 'corn.tif'};
            app.DropDown.ValueChangedFcn = createCallbackFcn(app, @DropDownValueChanged, true);
            app.DropDown.Position = [224 126 110 22];
            app.DropDown.Value = 'peppers.png';

            % Create PredefinedImagesLabel
            app.PredefinedImagesLabel = uilabel(app.UIFigure);
            app.PredefinedImagesLabel.HorizontalAlignment = 'right';
            app.PredefinedImagesLabel.Position = [109 126 106 22];
            app.PredefinedImagesLabel.Text = 'Predefined Images';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = GUI

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