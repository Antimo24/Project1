function [x_output, y_output] = interpolation(x_input, y_input, mesh_density)
%INTERPOLATION 此处显示有关此函数的摘要
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

% examine parameter inputed
switch nargin
    case 2
        mesh_density = 1;
    case 3
        try
            validateattributes(mesh_density, {'numeric'},...
            {'nonempty', 'numel', 1, 'real', 'nonnan', 'finite', '>=', 1, '<=', 100});
            mesh_density = floor(mesh_density);
        catch ME
            switch ME.identifier
                case 'MATLAB:notLessEqual'
                    mesh_density = 100;
                    warning('Inivalid interpolation factor.')
                otherwise
                    mesh_density = 1;
                    warning('Inivalid interpolation factor.')
            end
        end
    otherwise
        x_output = [];
        y_output = [];
%         error('Invalid parameter number.')
end


% validate input data
interp_method = 'spline';
x_input = isValidData(x_input, 'increasing');
y_input = isValidData(y_input);
[x_input, y_input] = isSameLength(x_input, y_input);
flag_isEven = isEvenlyDistributed(x_input);


% do the interpolation
if (flag_isEven && mesh_density==1)
    % do not interpolate if xaxis is evenly dist and mesh density is 1
    x_output = x_input;
    y_output = y_input;
else
    x_output = linspace(min(x_input), max(x_input), mesh_density*length(x_input)).';
    y_output = interp1(x_input, y_input, x_output, interp_method);
end

% plot
figure()
plot(x_input, y_input, 'x', 'linewidth', 1);
hold on
plot(x_output, y_output, 's-', 'linewidth',1);
hold off
xlabel('x', 'fontsize',12)
ylabel('y', 'fontsize', 12)
legend({"initial signal","interpolation"}, 'fontsize', 10, 'location', 'southwest')

end

