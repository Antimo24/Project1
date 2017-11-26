classdef Test_isEvenlyDistributed < matlab.unittest.TestCase
    %TEST_ISEVENLYDISTRIBUTED:a test class of function isEvenlyDistributed
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
        
        % standard evenly distributed data input
        function valid_input1(test)
            nData = 100;
            y = linspace(0,100,nData).';
            act_result = isEvenlyDistributed(y);
            exp_result = logical(true);
            test.verifyEqual(act_result,exp_result);  
        end
        
        % evenly input data with noise
        function valid_input2(test)
            nData = 100;
            y = linspace(0,100,nData).';
            noise = randn(size(y));
            y = y + noise./100;
            act_result = isEvenlyDistributed(y);
            exp_result = logical(true);
            test.verifyEqual(act_result,exp_result);  
        end
        
        % actrual data 1
        function valid_input3(test)
            data = load('NMR.csv');
            y = data(:,1);
            act_result = isEvenlyDistributed(y);
            exp_result = logical(true);
            test.verifyEqual(act_result,exp_result);  
        end
        
        % actrual data 2
        function valid_input4(test)
            data = load('KBr.csv');
            y = data(:,1);
            act_result = isEvenlyDistributed(y);
            exp_result = logical(true);
            test.verifyEqual(act_result,exp_result);  
        end
        
        % actural data 3
        function valid_input5(test)
            data = load('HCl-IR-long.csv');
            y = data(:,1);
            act_result = isEvenlyDistributed(y);
            exp_result = logical(true);
            test.verifyEqual(act_result,exp_result);  
        end
        
        % actual data 4
        function valid_input6(test)
            data = load('CO2-IR.csv');
            y = data(:,1);
            act_result = isEvenlyDistributed(y);
            exp_result = logical(true);
            test.verifyEqual(act_result,exp_result);  
        end
        
        % invalid data input 1
        function invalid_input1(test)
            y = [1;2;3;4;3;2;1;];
            act_result = isEvenlyDistributed(y);
            exp_result = logical(false);
            test.verifyEqual(act_result,exp_result);  
        end
        
        % invalid data input 2
        function invalid_input2(test)
            nData = 100;
            y = randn([nData,1]);
            act_result = isEvenlyDistributed(y);
            exp_result = logical(false);
            test.verifyEqual(act_result,exp_result);  
        end
        
        % invalid data input 3
        function invalid_input3(test)
            nData = 100;
            y = sort(randn([nData,1]));
            act_result = isEvenlyDistributed(y);
            exp_result = logical(false);
            test.verifyEqual(act_result,exp_result);  
        end
        
    end
end

