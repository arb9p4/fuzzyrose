function X = fuzzy_trapmf(a, b, c, d, N)
% FUZZY_TRAPMF Creates a trapezoidal fuzzy number using interval notation.
%
% X = fuzzy_trapmf(a, b, c, d) creates the trapezoidal fuzzy membership
% function defined by the parameters a, b, c, and d, which represent the
% minimum, left-most peak, right-most peak, and maximum control points
% respectively. X is in interval notation such that each row of X
% corresponds to an alpha-cut of the membership function. X(1,:) = [a, d]
% is the support and X(N,:) = [b, c] is the core. By default, N is set to
% 1000.
%
% X = fuzzy_trapmf(a, b, c, d, N) creates the trapezoidal fuzzy membership
% function as above, using the provided value for N.
%
%
% Example:
%   X = fuzzy_trapmf(1,2,3,4);

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
assert(a <= b && b <= c && c <= d, 'Control points must be in increasing order.');

% Create the left interval
if a == b
    X(:,1) = repmat(a, N, 1);
else
    X(:,1) = (a:(b-a)/(N-1):b)';
end

% Create the right interval
if c == d
    X(:,2) = repmat(c, N, 1);
else
    X(:,2) = (d:(c-d)/(N-1):c)';
end

end
