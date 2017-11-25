classdef Test_isSameLength < matlab.unittest.TestCase
    %   TEST_ISSAMELENGTH: a test class of function isSameLength
    %   
    %   ** NOTICE : to complete all test, annotated 'error;' in       **
    %   ** isValidData.m first.                                       **
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
    
    methods (Test)
        
        function valid_input(test)
        % Verifies valid input case
            x_input = randn([100,1]);
            y_input = randn([100,1]);
            exp_output = [x_input y_input];
            [act_output_x, act_output_y] = isSameLength(x_input,y_input);
            act_output = [act_output_x, act_output_y];
            test.verifyEqual(act_output,exp_output);    
        end
        
        function invalid_input(test)
        % Verifies valid input case
            x_input = randn([100,1]);
            y_input = randn([101,1]);
            exp_output = [];
            [act_output_x, act_output_y] = isSameLength(x_input,y_input);
            act_output = [act_output_x, act_output_y];
            test.verifyEqual(act_output,exp_output);    
        end
        
    end
end

