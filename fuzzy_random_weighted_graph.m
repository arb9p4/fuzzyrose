function G = fuzzy_random_weighted_graph(options)
% FUZZY_RANDOM_WEIGHTED_GRAPH Creates a urquhart graph from a set of
% randomly separated points, initialized with an optional random fuzzy
% weight vector on each node and/or edge.
%
% Example:
%   G = fuzzy_random_weighted_graph();

% Andrew Buck
% Copyright, University of Missouri, 2015

%% History
%  2015-01-16: Initial coding

% Create options structure if it is not provided
if ~exist('options', 'var')
    options = struct();
end

% Define default options
if ~isfield(options, 'directed')
    options.directed = true;
end
if ~isfield(options, 'bbox')
    options.bbox = [0 10 0 10];
end
if ~isfield(options, 'sep')
    options.sep = 2;
end
if ~isfield(options, 'edgeN')
    options.edgeN = 5;
end
if ~isfield(options, 'nodeN')
    options.nodeN = 5;
end
if ~isfield(options, 'maxVal')
    options.maxVal = 10;
end
if ~isfield(options, 'weights')
    options.weights = [1 1 1 1];
end
if ~isfield(options, 'skew')
    options.skew = 1;
end
if ~isfield(options, 'N')
    options.N = 1000;
end

% Set options
directed = options.directed;
bbox = options.bbox;
sep = options.sep;
edgeN = options.edgeN;
nodeN = options.nodeN;
maxVal = options.maxVal;
weights = options.weights;
skew = options.skew;
N = options.N;

% Get random node locations
[X, Y] = random_separated_points(bbox, sep);

% Create urquhart graph
A = urquhart_graph(X, Y);

% Create graph structure
G = [];
G.directed = directed;
G.edgeN = edgeN;
G.nodeN = nodeN;
G.N = N;

% Define node locations
G.xy = [X, Y];

% Create structural graph
G.As = A;

% Define edges
[i, j] = find(A);
G.edges = [i, j];

% Define edge weights
G.EdgeWeights = {};
for i = 1:size(G.edges,1)
    
    % Find index of opposite direction
    ind = find(G.edges(:,1) == G.edges(i,2) & G.edges(:,2) == G.edges(i,1), 1);
    
    % Get skewed weights
    w = ones(1, edgeN)*maxVal;
    for j = 2:edgeN
        w(j) = skew*w(j-1);
    end
    perm = randperm(edgeN);
    w = w(perm);
    
    for j = 1:edgeN
        G.EdgeWeights{i,j} =  fuzzy_randmf(w(j), weights, N);
        
        if ~directed
            G.EdgeWeights{ind,j} = G.EdgeWeights{i,j};
        end
    end
end

% Define node weights
G.NodeWeights = {};
for i = 1:size(G.xy,1)
    
    % Get skewed weights
    w = ones(1, edgeN)*maxVal;
    for j = 2:nodeN
        w(j) = skew*w(j-1);
    end
    perm = randperm(nodeN);
    w = w(perm);
    
    for j = 1:nodeN
        G.NodeWeights{i,j} = fuzzy_randmf(w(j), weights, N);
    end
end

end
