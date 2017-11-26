classdef Test_func_interpolation < matlab.unittest.TestCase
    %   TEST_FUNC_INTERPOLATION: a test class of function interpolation.m
    %   
    %   ** NOTICE : to complete all test, annotated 'error;' in       **
    %   ** interpolaton.m first.                                       **
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
        
        % Verifies valid input case
        function valid_input(test)
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            mesh_density = 10;
            
            
            exp_x = linspace(min(xdata), max(xdata), mesh_density*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % Verifies valid input case
        function valid_input2(test)
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            mesh_density = 100;
            
            
            exp_x = linspace(min(xdata), max(xdata), mesh_density*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % Verifies valid input case
        function valid_input3(test)
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            mesh_density = 1;
            
            
            exp_x = linspace(min(xdata), max(xdata), mesh_density*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % Verifies valid input case
        function valid_input4(test)
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            mesh_density = 56.1231837123;
            
            
            exp_x = linspace(min(xdata), max(xdata), floor(mesh_density)*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % Verifies valid input case
        function valid_input5(test)  
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            mesh_density = 99.9999;
            
            
            exp_x = linspace(min(xdata), max(xdata), floor(mesh_density)*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % Verifies valid input case
        function valid_input6(test)
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            mesh_density = 1.00001;
            
            
            exp_x = linspace(min(xdata), max(xdata), floor(mesh_density)*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % Verifies valid input case
        function valid_input7(test)
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            mesh_density = 0.01;
            
            
            exp_x = linspace(min(xdata), max(xdata), 1*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % Verifies valid input case
        function valid_input8(test)
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            mesh_density = 100.0001;
            
            
            exp_x = linspace(min(xdata), max(xdata), 100*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % Verifies valid input case
        function valid_input9(test)
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            mesh_density = -10.01213;
            
            
            exp_x = linspace(min(xdata), max(xdata), 1*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % Verifies valid input case
        function valid_input10(test)
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            mesh_density = 10 + 0.0012i;
            
            
            exp_x = linspace(min(xdata), max(xdata), 1*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % Verifies valid input case
        function valid_input11(test)
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            mesh_density = [];
            
            
            exp_x = linspace(min(xdata), max(xdata), 1*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % Verifies valid input case
        function valid_input12(test)
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            
            
            exp_x = linspace(min(xdata), max(xdata), 1*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % Verifies valid input case
        function valid_input13(test)
            nData = 5;
            xdata = sort(abs(randn([nData,1])));
            ydata = sort(randn([nData,1]));
            mesh_density = [1;2];
            
            
            exp_x = linspace(min(xdata), max(xdata), 1*nData).';
            exp_y = interp1(xdata, ydata, exp_x, 'spline');
            exp_output = [exp_x, exp_y];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % test by pass input (evenly distributed x and mesh density=1)
        function bypass_test1(test)
            nData = 5;
            xdata = [1;2;3;4;5];
            ydata = sort(randn([nData,1]));
            mesh_density = 1;
            
            exp_output = [xdata, ydata];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % test by pass input (evenly distributed x and mesh density=1)
        function bypass_test2(test)
            xdata = unifrnd([-1000:1:1000].',[-999:1:1001].');
            nData = length(xdata);
            ydata = sort(randn([nData,1]));
            mesh_density = 1;
            
            exp_output = [xdata, ydata];
            
            [interp_x, interp_y] = interpolation(xdata, ydata, mesh_density);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % test by pass input (real data)
        function bypass_test3(test)
            data = load('NMR.csv');
            xdata = data(:,1);
            ydata = data(:,2);
            
            exp_output = [xdata, ydata];
            
            [interp_x, interp_y] = interpolation(xdata, ydata);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
        % test by pass input (real data)
        function bypass_test4(test)
            data = load('KBr.csv');
            xdata = data(:,1);
            ydata = data(:,2);
           
            exp_output = [xdata, ydata];
            
            [interp_x, interp_y] = interpolation(xdata, ydata);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        % test by pass input (real data)
        function bypass_test5(test)
            data = load('HCl-IR-long.csv');
            xdata = data(:,1);
            ydata = data(:,2);
           
            exp_output = [xdata, ydata];
            
            [interp_x, interp_y] = interpolation(xdata, ydata);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        % test by pass input (real data)
        function bypass_test6(test)
            data = load('CO2-IR.csv');
            xdata = data(:,1);
            ydata = data(:,2);
           
            exp_output = [xdata, ydata];
            
            [interp_x, interp_y] = interpolation(xdata, ydata);
            act_output = [interp_x, interp_y];
            
            test.verifyEqual(act_output,exp_output);    
        end
        
    end

end

