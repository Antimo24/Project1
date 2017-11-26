function [ dy ] = numDerivative14(x, y)
%   numDerivative14   dy = numDerivative14(x, y)
%   calculate 1 order numerical derivative with 4 order uncertainty
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


    %---------------------------------------------------%
    % Basic input data processing
    x = isValidData(obj, x, 'increasing');
    y = isValidData(obj, y);
    [x, y] = isSameLength(obj, x, y);
    flag_even = isEvenlyDistributed(x);
    if ~flag_even
        error('Invalid Data Type.');
    end
    dh = mean(diff(x));
    nData = length(x);
    
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
            dy(idx) = centralFiniteDiff1(y(idx-2 : idx+2));
        elseif (idx<=2)
            dy(idx) = forwardFiniteDiff1(y(idx : idx+4));
        elseif (idx>=(nData-2))
            dy(idx) = backwardFiniteDiff1(y(idx-4 : idx));
        else
            error('\nIndex problem happened when calculating numerical differentiation\n');
        end
    end


end

