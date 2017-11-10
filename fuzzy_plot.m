function fuzzy_plot(A, options, h)
% FUZZY_PLOT Plots a vector of fuzzy numbers in the standard way.
%
% Example:
%   A = fuzzy_randmf_vector(5, 10);
%   fuzzy_plot(A);

% Andrew Buck
% Copyright, University of Missouri, 2017

%% History
%  2017-11-09: Initial coding
%%

% Create options structure if it is not provided
if ~exist('options', 'var')
    options = struct();
end

% Define default options
if ~isfield(options, 'limits')
    minX = min(A(:));
    maxX = max(A(:));
else
    if length(options.limits) == 1
        minX = 0;
        maxX = options.limits;
    else
        minX = options.limits(1);
        maxX = options.limits(2);
    end
end

% Set default figure parameters
if ~exist('h', 'var')
    figure;
else
    figure(h);
end

% Get the number of fuzzy sets
N = size(A,2)/2;

% Get the alpha values
alphas = (linspace(0, 1, size(A,1)))';

% Get the colormap
cmap_jet = jet(64);
if N > 1
    ci = ((1:N)-1)*63/(N-1)+1;
else
    ci = 33;
end
cmap = cmap_jet(round(ci),:);

% Prepare for drawing
hold on;

for i = 1:N
   
    % Get left and right sides
    L = A(:, (i-1)*2 + 1);
    R = A(:, (i-1)*2 + 2);
    
    X = [minX; L; flipud(R); maxX];
    Y = [0; alphas; flipud(alphas); 0];
    
    plot(X, Y, 'LineWidth', 2, 'Color', cmap(i,:));
    
end
