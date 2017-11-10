function X = fuzzy_randmf_vector(M, maxVal, weights, N)
% FUZZY_RANDMF_VECTOR Creates a vector of random fuzzy numbers in interval
% array notation.
%
% X = fuzzy_randmf_vector(M, maxVal) creates a vector of M random fuzzy
% numbers within the range [0, maxVal]. X is in interval array notation
% such that the first fuzzy number is in X(:,1:2), the second is in
% X(:,3:4), and so on. Each fuzzy number has an equal chance of being a
% crisp scalar, crisp interval, triangular fuzzy number, or trapezoidal
% fuzzy number. By default there are 1000 alpha-cuts.
%
% X = fuzzy_randmf_vector(M, maxVal, wieghts) creates a vector of random
% fuzzy numbers as above, but uses the given weights perameter to define
% the likelihood of choosing each fuzzy number type.
%
% X = fuzzy_randmf_vector(M, maxVal, weights, N) creates a vector of random
% fuzzy numbers as above with defined weights, using N alpha-cuts.
%
% Example:
%   X = fuzzy_randmf_vector(5, 10);

% Andrew Buck
% Copyright, University of Missouri, 2015

%% History
%  2015-01-16: Initial coding
%%

% Set equal weights if there are no supplied weight values
if(~exist('weights', 'var'))
	weights = [1, 1, 1, 1];
end

% Check if a specific number of alpha-cuts has been specified
if(~exist('N', 'var'))
	N = 1000;
end

% Create the vector of random fuzzy numbers
X = zeros(N, 2*M);
for i = 1:M
    X(:,2*i-1:2*i) = fuzzy_randmf(maxVal, weights, N);
end
    
end
