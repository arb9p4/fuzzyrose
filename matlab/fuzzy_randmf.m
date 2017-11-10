function X = fuzzy_randmf(maxVal, weights, N)
% FUZZY_RANDMF Creates a random fuzzy number using interval notation.
%
% X = fuzzy_randmf(maxVal) creates a random fuzzy number within the range
% [0, maxVal]. X is in interval notation and has an equal chance of being a
% crisp scalar, crisp interval, triangular fuzzy number, or trapezoidal
% fuzzy number. By default there are 1000 alpha-cuts.
%
% X = fuzzy_randmf(maxVal, wieghts) creates a random fuzzy number as above,
% but uses the given weights perameter to define the likelihood of choosing
% each fuzzy number type.
%
% X = fuzzy_randmf(maxVal, weights, N) creates a random fuzzy number as
% above with defined weights, using N alpha-cuts.
%
% Example:
%   X = fuzzy_randmf(10);

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

% Pick a type randomly
i = 1;
s = weights(1);
r = rand * sum(weights);
while s < r && i < 4
    i = i + 1;
    s = s + weights(i);
end

if i == 1
    
    % Singleton
    R = rand * maxVal;
    X = fuzzy_deltamf(R, N);
    
elseif i == 2
    
    % Interval
    R = rand(1,2) * maxVal;
    R = sort(R);
    X = fuzzy_rectmf(R(1), R(2), N);
    
elseif i == 3
    
    % Triangle
    R = rand(1,3) * maxVal;
    R = sort(R);
    X = fuzzy_trimf(R(1), R(2), R(3), N);
    
else
    
    % Trapezoid
    R = rand(1,4) * maxVal;
    R = sort(R);
    X = fuzzy_trapmf(R(1), R(2), R(3), R(4), N);
    
end
    
end
