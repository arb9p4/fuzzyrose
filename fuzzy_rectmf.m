function X = fuzzy_rectmf(a, b, N)
% FUZZY_RECTMF Creates a rectangular fuzzy number using interval notation.
%
% X = fuzzy_rectmf(a, b) creates the rectangular fuzzy membership function
% defined by the parameters a, and b, which represent the minimum, and
% maximum control points respectively. X is in interval notation such
% that each row of X corresponds to an alpha-cut of the membership
% function. There are N rows of X, all set to [a, b]. By default, N is set
% to 1000.
%
% X = fuzzy_rectmf(a, b, N) creates the rectangular fuzzy membership
% function as above, using the provided value for N.
%
%
% Example:
%   X = fuzzy_rectmf(1,2);

% Andrew Buck
% Copyright, University of Missouri, 2015

%% History
%  2015-01-20: Initial coding
%%

% Check if a specific number of alpha-cuts has been specified
if ~exist('N', 'var')
	N = 1000;
end

% Error checking
assert(a <= b, 'Control points must be in increasing order.');

% Create the membership function
X = repmat([a, b], N, 1);

end
