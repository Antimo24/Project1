classdef Data_2d < handle
    %   DATA_2D : A class of 2d spectrum data.
    %
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
    
    %---------------------------------------------------------------------%
    
    properties (SetAccess = private, GetAccess = public, SetObservable, GetObservable, AbortSet)
        % public properties
        m_units_x;              % units of xaxis
        m_units_y;              % units of yaxis
        m_name_x;               % name of xaxis
        m_name_y;               % name of yaxis
    end
    
    properties (SetAccess = private, GetAccess = private, SetObservable, GetObservable, AbortSet)
        % private properties
        m_xaxis;                % initial xaxis data
        m_yaxis;                % initial yaxia data
        m_interp_x;             % new xaxis after interplation
        m_interp_y;             % new yaxis after interplation
        m_dInterp_y;            % 1 order derivative for yaxis
        m_ddInterp_y;           % 2 order derivative for yaxis
        m_intInterp_y;          % integration of yaxis
        m_data_points;          % number of data points
        m_interp_density;       % interpolation mesh density; non-negative integer; 1 by default
        el_xaxis;               % event listener of xaxis (m_xaxis) changes
        el_yaxis;               % event listener of yaxis (m_yaxis) changes
        el_meshdensity;         % event listener of mesh density changes
    end
    
    %---------------------------------------------------------------------%
    
    events
        pop_error;                      % 
        pop_warning;                    %
        data_updated;                   % notified if method 'update' is called 
    end
    
    
    %---------------------------------------------------------------------%
    
    methods
        
        % constructor
        function obj = Data_2d(xdata, ydata)    
            %   DATA_2D constructor
            %   xdata: 1d column vector
            %   ydata: 1d column vector
            %-----------------------------------------%
            % plant flag to check input data structure
            % check vector size and data type
            xdata = isValidData(obj, xdata, 'increasing');
            ydata = isValidData(obj, ydata);
            [xdata, ydata] = isSameLength(obj, xdata, ydata);
            %-----------------------------------------%
            % set xaxis and yaxis
            obj.m_xaxis = xdata;
            obj.m_yaxis = ydata;
            %-----------------------------------------%
            % initialize other private properties
            obj.m_interp_density = int32(1);
            obj.m_data_points = length(obj.m_xaxis);
            obj.m_name_x = 'X';
            obj.m_name_y = 'Y';
            obj.m_units_x = [];
            obj.m_units_y = [];
            %-----------------------------------------%
            % data processing
            obj = interpolation(obj);
            obj = numDerivative14(obj);
            obj = numDerivative24(obj);
            obj = numIntegrate(obj);
            %-----------------------------------------%
            % add events listeners of value changes
            obj.el_xaxis = addlistener(obj,'m_xaxis','PostSet',...
                @(src,event)obj.update(obj,src,event));     % listener to xaxis changes
            obj.el_yaxis = addlistener(obj,'m_yaxis','PostSet',...
                @(src,event)obj.update(obj,src,event));     % listener to yaxis changes
            obj.el_meshdensity = addlistener(obj,'m_interp_density',...
                'PostSet',@(src,event)obj.update(obj,src,event)); % listener to mesh density changes
        end
        
        % get xaxis(m_xaxis) from out side
        function result = get_xaxis(obj)
        % get xaxis(m_xaxis) data from outside
            result = obj.m_xaxis;
        end
       
        % set xaxis(m_xaxis) from out side
        function obj = set_xaxis(obj, xdata)
            % determine if data is column vector
            % set xaxis(m_xaxis) data from outside 
            xdata = isValidData(obj, xdata, 'increasing');
            obj.m_xaxis = xdata;
        end
        
        % get yaxis(m_yaxis) data from outside
        function result = get_yaxis(obj)
            result = obj.m_yaxis;
        end
        
        % set yaxis(m_yaxis) data from outside
        function obj = set_yaxis(obj, ydata)
        % determine if data is column vector
        % set xaxis(m_xaxis) data from outside 
            ydata = isValidData(obj, ydata);
            obj.m_yaxis = ydata;
        end  
        
        % set mesh density(m_interp_density) data from outside
        function obj = set_meshdensity(obj, mesh_density)
            try
                validateattributes(mesh_density, {'numeric'},...
                    {'nonempty', 'numel', 1, 'real', '>=', 1, '<=', 100});
                obj.m_interp_density = floor(mesh_density);
            catch ME
                switch ME.identifier
                    case 'MATLAB:notLessEqual'
                        obj.m_interp_density = 100;
                        str_warning = 'Inivalid interpolation factor.';
                        notify(obj, 'pop_warning', EventMessage(str_warning));
                        warning(str_warning);
                    otherwise
                        obj.m_interp_density = 1;
                        str_warning = 'Inivalid interpolation factor.';
                        notify(obj, 'pop_warning', EventMessage(str_warning));
                        warning(str_warning);
                end
            end
        end
        
        % get mesh density(m_interp_density) data from outside
        function result = get_meshdensity(obj)
            result = int32(obj.m_interp_density);
        end
        
        % get interpolated xaxis data from outside
        function result = get_interpx(obj)
        % get interped x (m_interp_x) data from outside
            result = obj.m_interp_x;
        end
        
        % get interpolated yaxis data from outside
        function result = get_interpy(obj)
        % get interped y (m_interp_y) data from outside
            result = obj.m_interp_y;
        end
        
        % get 1 order numerical derivative data from outside
        function result = get_1orderDerivative(obj)
        % get interped y (m_interp_y) data from outside
            result = obj.m_dInterp_y;
        end
        
        % get 2 order numerical derivative data from outside
        function result = get_2orderDerivative(obj)
        % get interped y (m_interp_y) data from outside
            result = obj.m_ddInterp_y;
        end
        
        % get numerical integration data from outside
        function result = get_integration(obj)
        % get interped y (m_interp_y) data from outside
            result = obj.m_intInterp_y;
        end
        
        % set xlabel(m_name_x) from outside
        function obj = set_xlabel(obj, name_x)
        % determine if input is char or string
        % set xlabel(m_name_x) from outside
            if (isstring(name_x) || ischar(name_x))
                obj.m_name_x = name_x;
            else
                str_error = 'Invalid data type.';
                notify(obj, 'pop_error', EventMessage(str_error));
                error(str_error);
            end
        end
        
        % set xlabel(m_name_x) from outside
        function obj = set_ylabel(obj, name_y)
        % determine if input is string or char
        % set ylabel(m_name_y) from outside
            if (isstring(name_y) || ischar(name_y))
                obj.m_name_y = name_y;
            else
                str_error = 'Invalid data type.';
                notify(obj, 'pop_error', EventMessage(str_error));
                error(str_error);
            end
        end
        
        % set units of xaxis(m_units_x) from outside 
        function obj = set_xunits(obj, xunits)
        % determine if input is char or string
        % set units of xaxis(m_units_x) from outside
            if (isstring(xunits) || ischar(xunits))
                obj.m_units_x = xunits;
            else
                str_error = 'Invalid data type.';
                notify(obj, 'pop_error', EventMessage(str_error));
                error(str_error);
            end
        end
        
        % set units for yaxis(m_name_y) from outside
        function obj = set_yunits(obj, yunits)
        % determine if input is char or sting
        % set units for yaxis(m_name_y) from outside
            if (isstring(yunits) || ischar(yunits))
                obj.m_units_y = yunits;
            else
                str_error = 'Invalid data type.';
                notify(obj, 'pop_error', EventMessage(str_error));
                error(str_error);
            end
        end
        
        % get xlabel (m_name_x) from outside
        function result = get_xlabel(obj)
            result = obj.m_name_x;
        end
        
        % get ylabel (m_name_y) from outside
        function result = get_ylabel(obj)
            result = obj.m_name_y;
        end
        
        % get x units (m_units_x) from outside
        function result = get_xunits(obj)
            result = obj.m_units_x;
        end
        
        % get y units (m_units_y) from outside
        function result = get_yunits(obj)
            result = obj.m_units_y;
        end
        
        %
        function delete(obj)
            delete(obj.el_xaxis);
            delete(obj.el_yaxis);
            delete(obj.el_meshdensity);
        end
        
    end
    
    %---------------------------------------------------------------------%
    
    methods (Access = public)
        
        % doing interpolation to xaxis and yaxis using 'spline' method
        function obj = interpolation(obj)
            % get xaxis yaxis and mesh_density from obj
            % validate data above
            % interpolate data to specific density by 'spline' method
            % bypass if density is 1 and xaxis is evenly distributed
            % set interpx(m_interpx_x) and interpy(m_interp_y)
            %---------------------------------------------------%
            % initialization
            x_input = obj.m_xaxis;
            y_input = obj.m_yaxis;
            mesh_density = obj.get_meshdensity;
            interp_method = 'spline';
            %---------------------------------------------------%
            % validate input data
            try
                validateattributes(mesh_density, {'numeric'},...
                    {'nonempty', 'numel', 1, 'real', 'nonnan', 'finite', '>=', 1, '<=', 100});
                mesh_density = floor(mesh_density);
            catch ME
                switch ME.identifier
                    case 'MATLAB:notLessEqual'
                        mesh_density = 100;
                        str_warning = 'Inivalid interpolation factor.';
                        notify(obj, 'pop_warning', EventMessage(str_warning));
                        warning(str_warning);
                    otherwise
                        mesh_density = 1;
                        str_warning = 'Inivalid interpolation factor.';
                        notify(obj, 'pop_warning', EventMessage(str_warning));
                        warning(str_warning);
                end
            end
            x_input = isValidData(obj, x_input, 'increasing');
            y_input = isValidData(obj, y_input);
            [x_input, y_input] = isSameLength(obj, x_input, y_input);
            flag_isEven = isEvenlyDistributed(obj, x_input);
            %---------------------------------------------------%
            % do the interpolation
            if (flag_isEven && mesh_density==1)
                % do not interpolate if xaxis is evenly dist and mesh density is 1
                x_output = x_input;
                y_output = y_input;
            else
                x_output = linspace(min(x_input), max(x_input), mesh_density*length(x_input)).';
                y_output = interp1(x_input, y_input, x_output, interp_method);
            end
            %---------------------------------------------------%
            % pass output value to object
            obj.m_interp_x = x_output;
            obj.m_interp_y = y_output;
            %---------------------------------------------------%
        end
        
        % calculate 1 order numerical derivative with 4 order uncertainty
        function obj = numDerivative14(obj)
            %---------------------------------------------------%
            % Basic input data processing
            xdata = obj.m_interp_x;
            ydata = obj.m_interp_y;
            [xdata, ydata] = isSameLength(obj, xdata, ydata);
            dh = mean(diff(xdata));
            nData = length(xdata);
            %---------------------------------------------------%
            % First Order Direct Numerical Derivative Functions
            centralFiniteDiff1 = @(y) (1*y(1) - 8*y(2) + 8*y(4) -1*y(5)) ./ (12.*dh);
            forwardFiniteDiff1 = @(y) (-25*y(1) + 48*y(2) - 36*y(3) + 16*y(4) - 3*y(5)) ./ (12.*dh);
            backwardFiniteDiff1 = @(y) (3*y(1) - 16*y(2) + 36*y(3) - 48*y(4) + 25*y(5)) ./ (12.*dh);
            %---------------------------------------------------%
            % Derivatie Calculation
            dy = zeros(nData,1);
            for idx = 1 : 1 : nData
                if (idx>=3 && idx<=(nData-2))
                    dy(idx) = centralFiniteDiff1(ydata(idx-2 : idx+2));
                elseif (idx<=2)
                    dy(idx) = forwardFiniteDiff1(ydata(idx : idx+4));
                elseif (idx>=(nData-2))
                    dy(idx) = backwardFiniteDiff1(ydata(idx-4 : idx));
                else
                    str_error = 'Index problem happened when calculating numerical differentiation.';
                    notify(obj, 'pop_error', EventMessage(str_error));
                    error(str_error);
                end
            end
            obj.m_dInterp_y = dy;
            %---------------------------------------------------%
        end
        
        % calculate 2 order numerical derivative with 4 order uncertainty
        function obj = numDerivative24(obj)
            %---------------------------------------------------%
            % Basic input data processing
            xdata = obj.m_interp_x;
            ydata = obj.m_interp_y;
            [xdata, ydata] = isSameLength(obj, xdata, ydata);
            dh = mean(diff(xdata));
            nData = length(xdata);
            %---------------------------------------------------%
            % First Order Direct Numerical Derivative Functions
            centralFiniteDiff2 = @(y) (-1*y(1) + 16*y(2) - 30*y(3) + 16*y(4) - 1*y(5))./ (12.*dh.^2);
            forwardFiniteDiff2 = @(y) (35*y(1) - 104*y(2) + 114*y(3) - 56*y(4) + 11*y(5))./ (12.*dh.^2);
            backwardFiniteDiff2 = @(y) (11*y(1) - 56*y(2) + 114*y(3) - 104*y(4) + 35*y(5))./ (12.*dh.^2);
            %---------------------------------------------------%
            % Derivatie Calculation
            ddy = zeros([nData,1]);
            for idx = 1 : 1 : nData
                if (idx>=3 && idx<=(nData-2))
                    ddy(idx)= centralFiniteDiff2(ydata(idx-2 : idx+2));
                elseif (idx<=2)
                    ddy(idx)= forwardFiniteDiff2(ydata(idx : idx+4));
                elseif (idx>=(nData-2))
                    ddy(idx)= backwardFiniteDiff2(ydata(idx-4 : idx));
                else
                    str_error = 'Index problem happened when calculating numerical differentiation.';
                    notify(obj, 'pop_error', EventMessage(str_error));
                    error(str_error);
                end
            end
            obj.m_ddInterp_y = ddy;
            %---------------------------------------------------%
        end
        
        % calculate numerical integration using trapezoidal method
        function obj = numIntegrate(obj)
            %---------------------------------------------------%
            % Basic input data processing
            xdata = obj.m_interp_x;
            ydata = obj.m_interp_y;
            [xdata, ydata] = isSameLength(obj, xdata, ydata);
            %---------------------------------------------------%
            int_y = cumtrapz(xdata, ydata);
            obj.m_intInterp_y = int_y;
            %---------------------------------------------------%
        end
        
    end
    
    %---------------------------------------------------------------------%
    
    methods (Access = private)
        
        % exaim if input data is valid
        function [output_data, exitFlag] = isValidData(obj, input_data, str_increasing)
        % isValidData: exaim if input data is valid
        % valid data type: nonempty real numeric column & nonnan
        % return input data if it is valid, two exceptions
        % exp 1: if it's row vector, transpose it and examin again
        % exp 2: if it has nan, delete it and examin again
            %---------------------------------------------------%
            exitFlag = logical(false);
            %---------------------------------------------------%
            switch nargin
                case 2
                    flag_isIncreasing = logical(false);
                    str_increasing = 'none';
                case 3
                    flag_isIncreasing = strcmp(str_increasing, 'increasing');
                    if flag_isIncreasing
                        str_increasing = 'increasing';
                    else
                        str_increasing = 'none';
                    end
            end
            %---------------------------------------------------%
            try
                if flag_isIncreasing
                    validateattributes(input_data, {'numeric'},...
                        {'nonempty', 'column', 'real', 'nonnan', 'finite', 'increasing'})
                else
                    validateattributes(input_data, {'numeric'},...
                        {'nonempty', 'column', 'real', 'nonnan', 'finite'})
                end
                output_data = input_data;
                exitFlag = logical(true);
            catch ME
                switch ME.identifier
                    case 'MATLAB:expectedNonNaN'
                        output_data = input_data(~any(isnan(input_data),2));
                        str_warning = 'Invalid data type: Nan have been deleted.';
                        notify(obj, 'pop_warning', EventMessage(str_warning));
                        warning(str_warning);
                        output_data = isValidData(obj, output_data, str_increasing);
                    case 'MATLAB:expectedFinite'
                        output_data = input_data(~any(isinf(input_data),2));
                        str_warning = 'Invalid data type: Nan have been deleted.';
                        notify(obj, 'pop_warning', EventMessage(str_warning));
                        warning(str_warning);
                        output_data = isValidData(obj, output_data, str_increasing);
                    case 'MATLAB:expectedColumn'
                        output_data = input_data.';
                        str_warning = 'Invalid data type: row vector has been transposed to column vector.';
                        notify(obj, 'pop_warning', EventMessage(str_warning));
                        warning(str_warning);
                        output_data = isValidData(obj, output_data, str_increasing);
                    otherwise
                        output_data = [];
                        rethrow(ME);
                end
            end
            %---------------------------------------------------%
        end
        
        % examine if xaxis and yaxis are in same length
        function [x_output, y_output, exitFlag] = isSameLength(obj, x_input, y_input)
            % if it is, return input x and y
            % else, output warning and return empty array
            if (size(x_input) == size(y_input))
                x_output = x_input;
                y_output = y_input;
                exitFlag = logical(true);
            else
                x_output = [];
                y_output = [];
                exitFlag = logical(false);
                %str_error = 'Invalid data size.';
                %notify(obj, 'pop_error', EventMessage(str_error));
                %error(str_error);
            end
        end
        
        % examine if input data is evenly distributed using the chi-square test
        function result = isEvenlyDistributed(obj, input_data)
            % return logical 'ture' if it is, return logical 'false' if it's not.
            %---------------------------------------------------%
            signifcant_level = 5e-2;    % initialize significant level for chisq-test
            p_factor = 0.897;           % initialize p factor for chisq-test
            %---------------------------------------------------%
            uniform_pd = makedist('uniform',...
                'lower',min(input_data), 'upper', max(input_data));
            [notpass, p_value] = chi2gof(input_data, 'cdf', uniform_pd, 'alpha', signifcant_level);
            %---------------------------------------------------%
            if (~notpass && p_value >= p_factor)
                result = logical(true);
            else
                result = logical(false);
            end
            %---------------------------------------------------%
        end
        
    end
    
    %---------------------------------------------------------------------%

    methods (Static)
        % call back for upadte info
        function update(obj,src,evnt)
            switch src.Name
                case 'm_interp_density'
                    obj = interpolation(obj);
                    obj = numDerivative14(obj);
                    obj = numDerivative24(obj);
                    obj = numIntegrate(obj);
                    notify(obj, 'data_updated');
                case {'m_xaxis','m_yaxis'}
                    [~, ~, flag_sameLength] = isSameLength(obj, obj.m_xaxis, obj.m_yaxis);
                    if(flag_sameLength)
                        obj.m_data_points = length(obj.m_xaxis);
                        obj = interpolation(obj);
                        obj = numDerivative14(obj);
                        obj = numDerivative24(obj);
                        obj = numIntegrate(obj);
                        notify(obj, 'data_updated');
                    end
                otherwise
                    str_error = 'Update failed: Invalid updated case';
                    notify(obj, 'pop_error', EventMessage(str_warning));
                    error(str_warning);
            end
        end
        
    end
    
end

