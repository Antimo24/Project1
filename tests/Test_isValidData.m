classdef Test_isValidData < matlab.unittest.TestCase
    %   TEST_ISVALIDDATA: a test class of function isValidData
    %   
    %   ** NOTICE : to complete all test, annotated 'rethrow(ME);' in **
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
            input = sort(randn([100,1]));
            exp_output = input;
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);
        end
        
        function rowerror_input(test)
        % Verifies row vector input case
            input = sort(randn([1,100]));
            exp_output = input.';
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);            
        end
        
        function nanerror_input(test)
        % Verifies nan contained vector input case
            input = [nan; 1; nan; 2; nan; 3; nan; 4; 5; nan;];
            exp_output = [1;2;3;4;5];
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);  
        end
        
        function nanandrowerror_input(test)
        % Verifies nan contained row vector input case
            input = [nan; 1; nan; 2; nan; 3; nan; 4; 5; nan;].';
            exp_output = [1;2;3;4;5];
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);              
        end
        
        function nonincreasingerror1_input(test)
        % verifies non-increasing vector input case 1
            input = [1;1;1;1;1;1];
            exp_output = [];
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);
        end
        
        function nonincreasingerror2_input(test)
        % verifies non-increasing vector input case 2
            input = [-1;0;1;1;1;1;1;1;2;3;4;5;6];
            exp_output = [];
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);
        end
        
        function nonincreasingerror3_input(test)
        % verifies non-increasing vector input case 3
            input = [-1;0;1;0;-1;2;3;4;5;6];
            exp_output = [];
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);
        end
        
        function nonincreasingerror4_input(test)
        % verifies non-increasing vector input case 4 (random number)
            input = randn([100,1]);
            exp_output = [];
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);
        end
        
        function nonincreasingerror5_input(test)
        % verifies non-increasing vector input case 5 (nan and row)
            input = randn([1,101]);
            input([1;2;3;87;32;end]) = nan;
            exp_output = [];
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);
        end
        
        function emptyerror_input(test)
        % verifies empty input case
            input = [];
            exp_output = [];
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);
        end
        
        function complexerror1_input(test)
        % verifies complex number input case 1
            input = sort(randn([100,1]));
            input([1;2;3;4;12;34;65;87;end]) = [0+1i];
            exp_output = [];
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);
        end
        
        function complexerror2_input(test)
        % verifies complex number input case 2
            input = sort(randn([1,100]));
            input([1;2;3;4;12;34;65;87;end]) = [0+1i];
            exp_output = [];
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);
        end
        
        function complexerror3_input(test)
        % verifies complex number input case 3
            input = sort(randn([1,100]));
            input([1;2;3;4;12;34;65;87;end]) = [0+1i];
            input([2;4;56;25;99;end]) = nan;
            exp_output = [];
            act_output = isValidData(input);
            test.verifyEqual(act_output,exp_output);
        end
        
        function charerror_input(test)
        % verifies char input case
        input = 'char';
        exp_output = [];
        act_output = isValidData(input);
        test.verifyEqual(act_output,exp_output);
        end
        
        function stringerror_input1(test)
        % verifies string input case1
        input = "string";
        exp_output = [];
        act_output = isValidData(input);
        test.verifyEqual(act_output,exp_output);
        end       
        
        function stringerror_input2(test)
        % verifies string input case2
        input = ["This";"is";"a";"string";"array"];
        exp_output = [];
        act_output = isValidData(input);
        test.verifyEqual(act_output,exp_output);
        end          
        
        function mixedtypeerror_input2(test)
        % verifies mixed data input case
        input = {[1;2;3]; [1 2 3]; "This";"is";"a";"cell";'\n'};
        exp_output = [];
        act_output = isValidData(input);
        test.verifyEqual(act_output,exp_output);
        end      
        
    end
end

