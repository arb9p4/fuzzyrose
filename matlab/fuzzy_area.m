function A = fuzzy_area(X)
% FUZZY_AREA Computes the area under the curve of a function in interval
% notation.
%
% A = fuzzy_area(X) returns the area under the curve defined by the
% function X, which is in interval notation.
%
% Example:
%   X = fuzzy_trimf(1,2,3);
%   A = fuzzy_area(X);

% Andrew Buck
% Copyright, University of Missouri, 2015

%% History
%  2015-01-16: Initial coding
%%

% Convert to function form
N = size(X,1);
x = [X(:,1)', X(N:-1:1,2)'];
y = [0:1/(N-1):1, 1:-1/(N-1):0];

% Calculate area
A = trapz(x, y);

end
