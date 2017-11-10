function fuzzy_graph_plot(G, options, h)
% FUZZY_GRAPH_PLOT Plots a fuzzy weighted graph.
%
% Example:
%   G = fuzzy_random_weighted_graph();
%   fuzzy_graph_plot(G);

% Andrew Buck
% Copyright, University of Missouri, 2015

%% History
%  2015-01-16: Initial coding
%  2017-11-09: Bug fixes
%%

% Create options structure if it is not provided
if ~exist('options', 'var')
    options = struct();
end

% Define default options
if ~isfield(options, 'divergentColors')
    options.divergentColors = true;
end

if(~exist('h', 'var'))
    figure;
    h = gca;
end

% Determine some default values
D = squareform(pdist(G.xy));
plotWidth = median(D(G.As > 0)) / 2;
edgeWeights = cell2mat(G.EdgeWeights);
if isempty(edgeWeights)
    edgeWeights = 0;
end
nodeWeights = cell2mat(G.NodeWeights);
if isempty(nodeWeights)
    nodeWeights = 0;
end
maxVal = max(max(edgeWeights(:)), max(nodeWeights(:)));
plotScale = plotWidth/2 / maxVal;
gridSpacing = 1;

% Set figure properties
axes(h);
cla;
set(gca, 'Visible', 'off');
set(gcf, 'Color', 'w');
colormap jet;


% Draw edges
plottedEdges = zeros(size(G.edges,1),1);
for i = 1:size(G.edges,1)
    
    if plottedEdges(i) == 0
    
        % Mark as plotted
        plottedEdges(i) = 1;
        
        A1 = cell2mat(G.EdgeWeights(i,:));

        if G.directed
            % Determine if there is an edge in the other direction
            ind = find(G.edges(:,1) == G.edges(i,2) & G.edges(:,2) == G.edges(i,1));
            A2 = zeros(2,size(A1,2));
            if ~isempty(ind)
                A2 = cell2mat(G.EdgeWeights(ind,:));
                plottedEdges(ind) = 1;
            end
        else
            A2 = A1;
        end
        
        arc_opts = [];
        arc_opts.plotScale = plotScale;
        arc_opts.gridSpacing = gridSpacing;
        arc_opts.plotWidth = plotWidth;
        arc_opts.drawGrid = false;
        arc_opts.drawRefAxis = true;
        arc_opts.directed = G.directed;
        
        fuzzy_arc_plot(A1, A2, G.xy(G.edges(i,:),1), G.xy(G.edges(i,:),2), arc_opts, gca);
        
        axis tight;
        
    end
    
end


% Draw nodes
for i = 1:size(G.xy,1)
    
    fr_opts = [];
    fr_opts.x = G.xy(i,1);
    fr_opts.y = G.xy(i,2);
    fr_opts.plotScale = plotScale * plotWidth / size(G.EdgeWeights,2);
    fr_opts.gridSpacing = gridSpacing;
    fr_opts.drawGrid = false;
    fr_opts.showInterval = false;
    fr_opts.lineWidth = 1;
    fr_opts.offset = 0.15;

    if options.divergentColors
        fr_opts.colorOffset = max(G.edgeN,G.nodeN) + min(G.edgeN,G.nodeN)/2;
    else
        fr_opts.colorOffset = 0;
    end
        
    if G.nodeN > 0
        fuzzy_rose_plot(cell2mat(G.NodeWeights(i,:)), fr_opts, gca);
    else
        fuzzy_rose_plot([0 0], fr_opts, gca);
    end
    
    text(G.xy(i,1), G.xy(i,2), 5, num2str(i), 'HorizontalAlign', 'Center', 'FontWeight', 'bold');
    
    axis tight;
    
end

axis equal;
drawnow;

end
