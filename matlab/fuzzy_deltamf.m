function X = fuzzy_deltamf(a, N)
% FUZZY_DELTAMF Creates a singlge crisp value represented as a fuzzy number
% using interval notation.
%
% X = fuzzy_deltamf(a) creates the fuzzy membership function representing
% the crisp value a. X is in interval notation such that each row of X
% corresponds to an alpha-cut of the membership function. There are N rows
% of X, all set to [a, a]. By default, N is set to 1000.
%
% X = fuzzy_deltamf(a, N) creates the fuzzy membership function as above,
% using the provided value for N.
%
%
% Example:
%   X = fuzzy_deltamf(1);

% Andrew Buck
% Copyright, University of Missouri, 2015

%% History
%  2015-01-20: Initial coding
%%

% Check if a specific number of alpha-cuts has been specified
if ~exist('N', 'var')
	N = 1000;
end

% Create the membership function
X = repmat([a, a], N, 1);

end
