classdef DataAnalyser < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        DataAnalyserUIFigure       matlab.ui.Figure
        TabGroup                   matlab.ui.container.TabGroup
        ImportDataTab              matlab.ui.container.Tab
        InitialDataTable           matlab.ui.control.Table
        DataBrowserPanel           matlab.ui.container.Panel
        ImportButton               matlab.ui.control.Button
        XAxisPanel                 matlab.ui.container.Panel
        NameEditFieldLabel         matlab.ui.control.Label
        XNameEditField             matlab.ui.control.EditField
        UnitsEditFieldLabel        matlab.ui.control.Label
        XUnitsEditField            matlab.ui.control.EditField
        YAxisPanel                 matlab.ui.container.Panel
        NameEditField_2Label       matlab.ui.control.Label
        YNameEditField             matlab.ui.control.EditField
        UnitsEditField_2Label      matlab.ui.control.Label
        YUnitsEditField            matlab.ui.control.EditField
        DisplayTab                 matlab.ui.container.Tab
        DisplayOptionsPanel        matlab.ui.container.Panel
        initialdataCheckBox        matlab.ui.control.CheckBox
        orderderivativeCheckBox    matlab.ui.control.CheckBox
        orderderivativeCheckBox_2  matlab.ui.control.CheckBox
        integrationCheckBox        matlab.ui.control.CheckBox
        meshdensitySlider          matlab.ui.control.Slider
        MeshDensityLabel           matlab.ui.control.Label
        UIAxes                     matlab.ui.control.UIAxes
        ExportDataTab              matlab.ui.container.Tab
        ResultDataTable            matlab.ui.control.Table
        SaveDataButton             matlab.ui.control.Button
    end

    
    properties (Access = public)
        model_obj                  Data_2d                  % model part of MVC structure
        control_obj                DataAnalyser_Controller  % control part of MVC structure
        handle_legend              matlab.graphics.illustration.Legend % Description
        lineH_initialData          matlab.graphics.primitive.Line % Description
        lineH_1orderDerivative     matlab.graphics.primitive.Line % Description
        lineH_2orderDerivative     matlab.graphics.primitive.Line % Description
        lineH_integration          matlab.graphics.primitive.Line % Description
    end
    
    methods (Access = private)
        
        % regeister callbacks for view(this app) in controller(DataAnalyser_Controller)
        function attachToController(app, controller)
            % register callback for ImportButton in controller
            hFunc_callback_ImportButton = @controller.callback_ImportButton;
            addlistener(app.ImportButton,'ButtonPushed',hFunc_callback_ImportButton);
            
            % register callback for XNameEditField in controller
            hFunc_callback_XNameEditField = @controller.callback_XNameEditField;
            addlistener(app.XNameEditField,'ValueChanged',hFunc_callback_XNameEditField);
            
            % register callback for XUnitsEditField in controller
            hFunc_callback_XUnitsEditField = @controller.callback_XUnitsEditField;
            addlistener(app.XUnitsEditField,'ValueChanged',hFunc_callback_XUnitsEditField);
            
            % register callback for YNameEditField in controller
            hFunc_callback_YNameEditField = @controller.callback_YNameEditField;
            addlistener(app.YNameEditField,'ValueChanged',hFunc_callback_YNameEditField);
            
            % register callback for XUnitsEditField in controller
            hFunc_callback_YUnitsEditField = @controller.callback_YUnitsEditField;
            addlistener(app.YUnitsEditField,'ValueChanged',hFunc_callback_YUnitsEditField);
            
            % register callback for mesh density slider
            hFunc_callback_meshdensitySlider = @controller.callback_meshDensitySlider; 
            addlistener(app.meshdensitySlider,'ValueChanged',hFunc_callback_meshdensitySlider);
            
            % register callback for checkboxes in app
            addlistener(app.initialdataCheckBox, 'ValueChanged', @app.decideWhatToPlot);
            addlistener(app.orderderivativeCheckBox, 'ValueChanged', @app.decideWhatToPlot);
            addlistener(app.orderderivativeCheckBox_2, 'ValueChanged', @app.decideWhatToPlot);
            addlistener(app.integrationCheckBox, 'ValueChanged', @app.decideWhatToPlot);
            
            % register callback for SaveDataButtion in app
            addlistener(app.SaveDataButton, 'ButtonPushed', @app.saveData);
            
        end
        
        % decide what to plot after data updated
        function decideWhatToPlot(app,src,event)
            % initial data
            if(app.initialdataCheckBox.Value)
                app.plotInitialData(app.model_obj.get_xaxis, app.model_obj.get_yaxis);
            else
                delete(app.lineH_initialData);
            end
            % 1 order derivative
            if(app.orderderivativeCheckBox.Value)
                app.plot1OrderDerivative(app.model_obj.get_interpx, app.model_obj.get_1orderDerivative);
            else
                delete(app.lineH_1orderDerivative);
            end
            % 2 order derivative
            if(app.orderderivativeCheckBox_2.Value)
                app.plot2OrderDerivative(app.model_obj.get_interpx, app.model_obj.get_2orderDerivative);
            else
                delete(app.lineH_2orderDerivative);
            end
            % integration
            if(app.integrationCheckBox.Value)
                app.plotIntegration(app.model_obj.get_interpx, app.model_obj.get_integration);
            else
                delete(app.lineH_integration);
            end
        end
        
        % method to plot initial data
        function plotInitialData(app,xdata,ydata)
            delete(allchild(app.UIAxes));
            app.lineH_initialData = line(app.UIAxes,...
                'xdata', xdata,...
                'ydata', ydata,...
                'linestyle', '-',... 
                'color', [0,0.45,0.74]);
            app.handle_legend.String(end) = {'initial data'};
        end
        
        % method to plot 1 order derivative
        function plot1OrderDerivative(app,xdata,ydata)
            autoScale1 = max(app.model_obj.get_interpy) ./ (max(ydata)*2); 
            ydata = autoScale1 .* ydata;
            delete(app.lineH_1orderDerivative);
            app.lineH_1orderDerivative = line(app.UIAxes,...
                'xdata', xdata,...
                'ydata', ydata,...
                'linestyle', '--',... 
                'color', [0.85,0.33,0.10]);
            app.handle_legend.String(end) = {'1 order derivative'};
        end
        
        % method to plot 2 order derivative
        function plot2OrderDerivative(app,xdata,ydata)
            autoScale2 = (max(app.model_obj.get_1orderDerivative) ./ (max(ydata)*2)) ...
                .* (max(app.model_obj.get_interpy) ./ (max(ydata)*2));
            ydata = autoScale2 .* ydata;
            delete(app.lineH_2orderDerivative);
            app.lineH_2orderDerivative = line(app.UIAxes,...
                'xdata', xdata,...
                'ydata', ydata,...
                'linestyle', '-.',...
                'color', [0.93,0.69,0.13]);
            app.handle_legend.String(end) = {'2 order derivative'};
        end
        
        % method to ploy integration
        function plotIntegration(app,xdata,ydata)
            delete(app.lineH_integration);
            app.lineH_integration = line(app.UIAxes,...
                'xdata', xdata,...
                'ydata', ydata,...
                'linestyle', '-',...
                'color', [0.47,0.67,0.19]);
            app.handle_legend.String(end) = {'integration'};
        end
        
        function setXLabel(app, src, event)
            strXLabel = strcat(app.model_obj.get_xlabel, 32, app.model_obj.get_xunits);
            app.UIAxes.XLabel.String = strXLabel;
            app.InitialDataTable.ColumnName(1) = {app.model_obj.get_xlabel};
        end
        
        function setYLabel(app, src, event)
            strYLabel = strcat(app.model_obj.get_ylabel, 32, app.model_obj.get_yunits);
            app.UIAxes.YLabel.String = strYLabel;
            app.InitialDataTable.ColumnName(2) = {app.model_obj.get_ylabel};
        end
        
        function updateTable(app, src, event)
            app.InitialDataTable.Data = [app.model_obj.get_xaxis, app.model_obj.get_yaxis];
            app.ResultDataTable.Data = [app.model_obj.get_interpx,...
                app.model_obj.get_interpy,...
                app.model_obj.get_1orderDerivative,...
                app.model_obj.get_2orderDerivative,...
                app.model_obj.get_integration];
        end
        
        function saveData(app,src,event)
            outputData = num2cell(app.ResultDataTable.Data);
            outputRows = length(outputData)+1;
            output = cell([outputRows,5]);
            output(1,:) = app.ResultDataTable.ColumnName;
            output(2:end,:) = outputData;
            [fileName, pathName, filterIndex] = uiputfile({'*.csv';'*.xls';'*.xlsx'},'Save as');
            if(filterIndex)
                filePath = strcat(pathName, fileName);
                xlswrite(filePath, output);
            end
        end
        
    end
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % instantiate legend handel under UIAxes
            app.handle_legend = legend(app.UIAxes, {}, 'location', 'northeast');
            % set data tables
            app.InitialDataTable.RowName = 'numbered';
            app.ResultDataTable.RowName = 'numbered';
            % instantiate control_obj and attach to it
            x0 = linspace(0,3,60).';
            y0 = sin(x0);
            app.model_obj = Data_2d(x0,y0);
            app.control_obj = DataAnalyser_Controller(app, app.model_obj);
            app.attachToController(app.control_obj);                   % need corresponding method
            % add listener to events in model_obj
            addlistener(app.model_obj, 'pop_error', @app.showError);
            addlistener(app.model_obj, 'pop_warning', @app.showWarning);
            addlistener(app.model_obj, 'data_updated', @app.decideWhatToPlot);
            addlistener(app.model_obj, 'data_updated', @app.updateTable);
            % add listener to predefined events in model_obj
            addlistener(app.model_obj, 'm_name_x', 'PostSet', @app.setXLabel);
            addlistener(app.model_obj, 'm_name_y', 'PostSet', @app.setYLabel);
            addlistener(app.model_obj, 'm_units_x', 'PostSet', @app.setXLabel);
            addlistener(app.model_obj, 'm_units_y', 'PostSet', @app.setYLabel);
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create DataAnalyserUIFigure
            app.DataAnalyserUIFigure = uifigure;
            app.DataAnalyserUIFigure.Color = [1 1 1];
            app.DataAnalyserUIFigure.Position = [100 100 640 480];
            app.DataAnalyserUIFigure.Name = 'DataAnalyser';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.DataAnalyserUIFigure);
            app.TabGroup.Position = [1 1 640 480];

            % Create ImportDataTab
            app.ImportDataTab = uitab(app.TabGroup);
            app.ImportDataTab.Title = 'Import Data';
            app.ImportDataTab.BackgroundColor = [1 1 1];

            % Create InitialDataTable
            app.InitialDataTable = uitable(app.ImportDataTab);
            app.InitialDataTable.ColumnName = {'xaxis'; 'yaxis'};
            app.InitialDataTable.RowName = {};
            app.InitialDataTable.Position = [371 24 233 409];

            % Create DataBrowserPanel
            app.DataBrowserPanel = uipanel(app.ImportDataTab);
            app.DataBrowserPanel.TitlePosition = 'centertop';
            app.DataBrowserPanel.Title = 'Data Browser';
            app.DataBrowserPanel.BackgroundColor = [1 1 1];
            app.DataBrowserPanel.Position = [63 343 258 90];

            % Create ImportButton
            app.ImportButton = uibutton(app.DataBrowserPanel, 'push');
            app.ImportButton.Position = [79 26 100 22];
            app.ImportButton.Text = 'Import';

            % Create XAxisPanel
            app.XAxisPanel = uipanel(app.ImportDataTab);
            app.XAxisPanel.TitlePosition = 'centertop';
            app.XAxisPanel.Title = 'X Axis';
            app.XAxisPanel.BackgroundColor = [1 1 1];
            app.XAxisPanel.Position = [63 181 260 133];

            % Create NameEditFieldLabel
            app.NameEditFieldLabel = uilabel(app.XAxisPanel);
            app.NameEditFieldLabel.HorizontalAlignment = 'right';
            app.NameEditFieldLabel.Position = [58 82 38 15];
            app.NameEditFieldLabel.Text = 'Name';

            % Create XNameEditField
            app.XNameEditField = uieditfield(app.XAxisPanel, 'text');
            app.XNameEditField.Position = [111 78 100 22];

            % Create UnitsEditFieldLabel
            app.UnitsEditFieldLabel = uilabel(app.XAxisPanel);
            app.UnitsEditFieldLabel.HorizontalAlignment = 'right';
            app.UnitsEditFieldLabel.Position = [63 39 33 15];
            app.UnitsEditFieldLabel.Text = 'Units';

            % Create XUnitsEditField
            app.XUnitsEditField = uieditfield(app.XAxisPanel, 'text');
            app.XUnitsEditField.Position = [111 35 100 22];

            % Create YAxisPanel
            app.YAxisPanel = uipanel(app.ImportDataTab);
            app.YAxisPanel.TitlePosition = 'centertop';
            app.YAxisPanel.Title = 'Y Axis';
            app.YAxisPanel.BackgroundColor = [1 1 1];
            app.YAxisPanel.Position = [63 24 260 133];

            % Create NameEditField_2Label
            app.NameEditField_2Label = uilabel(app.YAxisPanel);
            app.NameEditField_2Label.HorizontalAlignment = 'right';
            app.NameEditField_2Label.Position = [58 82 38 15];
            app.NameEditField_2Label.Text = 'Name';

            % Create YNameEditField
            app.YNameEditField = uieditfield(app.YAxisPanel, 'text');
            app.YNameEditField.Position = [111 78 100 22];

            % Create UnitsEditField_2Label
            app.UnitsEditField_2Label = uilabel(app.YAxisPanel);
            app.UnitsEditField_2Label.HorizontalAlignment = 'right';
            app.UnitsEditField_2Label.Position = [63 39 33 15];
            app.UnitsEditField_2Label.Text = 'Units';

            % Create YUnitsEditField
            app.YUnitsEditField = uieditfield(app.YAxisPanel, 'text');
            app.YUnitsEditField.Position = [111 35 100 22];

            % Create DisplayTab
            app.DisplayTab = uitab(app.TabGroup);
            app.DisplayTab.Title = 'Display';
            app.DisplayTab.BackgroundColor = [1 1 1];

            % Create DisplayOptionsPanel
            app.DisplayOptionsPanel = uipanel(app.DisplayTab);
            app.DisplayOptionsPanel.TitlePosition = 'centertop';
            app.DisplayOptionsPanel.Title = '          Display Options';
            app.DisplayOptionsPanel.BackgroundColor = [1 1 1];
            app.DisplayOptionsPanel.Position = [1 1 637 83];

            % Create initialdataCheckBox
            app.initialdataCheckBox = uicheckbox(app.DisplayOptionsPanel);
            app.initialdataCheckBox.Text = 'initial data';
            app.initialdataCheckBox.Position = [62 35 80 15];

            % Create orderderivativeCheckBox
            app.orderderivativeCheckBox = uicheckbox(app.DisplayOptionsPanel);
            app.orderderivativeCheckBox.Text = '1 order derivative';
            app.orderderivativeCheckBox.Position = [192 35 115 15];

            % Create orderderivativeCheckBox_2
            app.orderderivativeCheckBox_2 = uicheckbox(app.DisplayOptionsPanel);
            app.orderderivativeCheckBox_2.Text = '2 order derivative';
            app.orderderivativeCheckBox_2.Position = [357 35 115 15];

            % Create integrationCheckBox
            app.integrationCheckBox = uicheckbox(app.DisplayOptionsPanel);
            app.integrationCheckBox.Text = 'integration';
            app.integrationCheckBox.Position = [521 35 80 15];

            % Create meshdensitySlider
            app.meshdensitySlider = uislider(app.DisplayOptionsPanel);
            app.meshdensitySlider.Limits = [1 100];
            app.meshdensitySlider.MajorTicks = [];
            app.meshdensitySlider.MajorTickLabels = {};
            app.meshdensitySlider.MinorTicks = [];
            app.meshdensitySlider.Position = [149 14 452 3];
            app.meshdensitySlider.Value = 1;

            % Create MeshDensityLabel
            app.MeshDensityLabel = uilabel(app.DisplayOptionsPanel);
            app.MeshDensityLabel.Position = [61 10 78 15];
            app.MeshDensityLabel.Text = 'Mesh Density';

            % Create UIAxes
            app.UIAxes = uiaxes(app.DisplayTab);
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.FontSize = 14;
            app.UIAxes.ColorOrder = [0 0.451 0.7412;0.851 0.3294 0.102;0.9294 0.6902 0.1294;0.4941 0.1843 0.5569;0.4706 0.6706 0.1882;0.302 0.7451 0.9333;0.6353 0.0784 0.1843];
            app.UIAxes.GridLineStyle = '--';
            app.UIAxes.Box = 'on';
            app.UIAxes.NextPlot = 'add';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.BackgroundColor = [1 1 1];
            app.UIAxes.Position = [1 93 637 363];

            % Create ExportDataTab
            app.ExportDataTab = uitab(app.TabGroup);
            app.ExportDataTab.Title = 'Export Data';
            app.ExportDataTab.BackgroundColor = [1 1 1];

            % Create ResultDataTable
            app.ResultDataTable = uitable(app.ExportDataTab);
            app.ResultDataTable.ColumnName = {'xaxis'; 'yaxis'; '1 order derivative'; '2 order derivative'; 'intergration'};
            app.ResultDataTable.RowName = {};
            app.ResultDataTable.Position = [27 38 586 397];

            % Create SaveDataButton
            app.SaveDataButton = uibutton(app.ExportDataTab, 'push');
            app.SaveDataButton.Position = [27 9 586 22];
            app.SaveDataButton.Text = 'Save Data';
        end
    end

    methods (Access = public)

        % Construct app
        function app = DataAnalyser

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.DataAnalyserUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.DataAnalyserUIFigure)
        end
    end
end