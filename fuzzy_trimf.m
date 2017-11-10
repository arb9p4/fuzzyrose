function X = fuzzy_trimf(a, b, c, N)
% FUZZY_TRIMF Creates a triangular fuzzy number using interval notation.
%
% X = fuzzy_trimf(a, b, c) creates the triangular fuzzy membership function
% defined by the parameters a, b, and c, which represent the minimum, peak,
% and maximum control points respectively. X is in interval notation such
% that each row of X corresponds to an alpha-cut of the membership
% function. X(1,:) = [a, c] is the support and X(N,:) = [b, b] is the core.
% By default, N is set to 1000.
%
% X = fuzzy_trimf(a, b, c, N) creates the triangular fuzzy membership
% function as above, using the provided value for N.
%
%
% Example:
%   X = fuzzy_trimf(1,2,3);

% Andrew Buck
% Copyright, University of Missouri, 2015

%% History
%  2015-01-16: Initial coding
%%

% Check if a specific number of alpha-cuts has been specified
if(~exist('N', 'var'))
	N = 1000;
end

% Error checking
assert(a <= b && b <= c, 'Control points must be in increasing order.');

% Create the left interval
if a == b
    X(:,1) = repmat(a, N, 1);
else
    X(:,1) = (a:(b-a)/(N-1):b)';
end

% Create the right interval
if b == c
    X(:,2) = repmat(b, N, 1);
else
    X(:,2) = (c:(b-c)/(N-1):b)';
end

end
