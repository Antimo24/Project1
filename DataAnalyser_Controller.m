classdef DataAnalyser_Controller < handle
    %DATAANALYSER_CONTROLLER : the controller part of DataAnalyser app (in MVC frame)
    %   Copyright 2017 Wenjie Liao
    %
    %   Licensed under the Apache License, Version 2.0 (the "License");
    %   you may not use this file except in compliance with the License.
    %   You may obtain a copy of the License at
    %
    %   http://www.apache.org/licenses/LICENSE-2.0
    %
    %   Unless required by applicable law or agreed to in writing, software
    %   distributed under the License is distributed on an "AS IS" BASIS,
    %   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    %   See the License for the specific language governing permissions and
    %   limitations under the License.
    
    properties
        viewObj;
        modelObj;
    end
    
    methods
        % constructor
        function obj = DataAnalyser_Controller(view, model)
            %   此处显示详细说明
            obj.viewObj = view;
            obj.modelObj = model;
        end
        
        % callback function of ImportButton
        function callback_ImportButton(obj, src, event)
            [fileName,pathName,filterIndex] = uigetfile('*.*','Import Data');
            if (filterIndex)
                filePath = strcat(pathName, fileName);
                initialData = load(filePath);
                set_xaxis(obj.modelObj, initialData(:,1));
                set_yaxis(obj.modelObj, initialData(:,2));
            end
        end
        
        % callback function of NameEditField;
        function callback_XNameEditField(obj, src, event)
            xName = src.Value;
            set_xlabel(obj.modelObj, xName);
        end
        
        % callback funtion of XUnitsEditField
        function callback_XUnitsEditField(obj, src, event)
            xUnits = src.Value;
            set_xunits(obj.modelObj, xUnits);
        end
        
        % callback function of NameEditField;
        function callback_YNameEditField(obj, src, event)
            yName = src.Value;
            set_ylabel(obj.modelObj, yName);
        end
        
        % callback funtion of XUnitsEditField
        function callback_YUnitsEditField(obj, src, event)
            yUnits = src.Value;
            set_yunits(obj.modelObj, yUnits);
        end
        
        % callback function of meshdensitySlider
        function callback_meshDensitySlider(obj, src, event)
            meshDensity = src.Value;
            set_meshdensity(obj.modelObj, meshDensity);
        end
        
    end

end
