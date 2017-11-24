%   test_interpolation : A script of testing methods of finding outlier.
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
 
clc;clear
%-------------------------------------------------------------------------%

nData = 10;
xaxis = randn([nData,1]);
xaxis = sort(xaxis);
yaxis = randn(size(xaxis));

figure(1)
plot(xaxis, yaxis, 'x', 'linewidth', 1);
str_legend = {"initial signal"};

nInterp = 100;
method = 'spline';
interp_x = (linspace(min(xaxis), max(xaxis), nInterp)).';
interp_y = interp1(xaxis,yaxis,interp_x, method);

figure(1)
hold on
plot(interp_x, interp_y, 's-', 'linewidth',1);
hold off
str_legend(end+1) = {"interpolation"};
xlabel('x', 'fontsize',12)
ylabel('y', 'fontsize', 12)
legend(str_legend, 'fontsize', 10, 'location', 'southwest')