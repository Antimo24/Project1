function output_data = isValidData(input_data)
% isValidData: exaim if input data is valid
% valid data type: nonempty real numeric column & nonnan
% return input data if it is valid, two exceptions
% exp 1: if it's row vector, transpose it and examin again
% exp 2: if it has nan, delete it and examin again
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
try
    validateattributes(input_data, {'numeric'},...
        {'nonempty', 'column', 'real', 'nonnan', 'increasing'})
    output_data = input_data;
catch ME
    switch ME.identifier
        case 'MATLAB:expectedNonNaN'
            output_data = input_data(~any(isnan(input_data),2));
            warning('Invalid data type: Nan have been deleted.')
            output_data = isValidData(output_data);
        case 'MATLAB:expectedColumn'
            output_data = input_data.';
            warning('Invalid data type: row vector has been transposed to column vector.')
            output_data = isValidData(output_data);
        otherwise
            output_data = [];
%             rethrow(ME);
    end
end
end

