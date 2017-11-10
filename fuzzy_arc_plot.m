function fuzzy_arc_plot(A1, A2, X, Y, options, h)
% FUZZY_ARC_PLOT Generates a straight line plot of a vector of fuzzy 
% numbers using the cumulative petal approach of the fuzzy rose for use in
% generating directed and undirected arcs in a fuzzy weighted graph.
%
% Example:
%   A = fuzzy_randmf_vector(5, 10);
%   fuzzy_arc_plot(A, [], [0,50], [0,0]);

% Andrew Buck
% Copyright, University of Missouri, 2015

%% History
%  2014-06-25: Initial coding
%  2015-01-16: Cleanup / Added options
%%

% Determine an optimal default plot width
plotWidth = sqrt((X(2)-X(1))^2 + (Y(2)-Y(1))^2) * 0.75;

% Create options structure if it is not provided
if ~exist('options', 'var')
    options = struct();
end

% Define default options
if ~isfield(options, 'directed')
    options.directed = true;
end
if ~isfield(options, 'plotWidth')
    options.plotWidth = plotWidth;
end
if ~isfield(options, 'plotScale')
    options.plotScale = 1;
end
if ~isfield(options, 'gridSpacing')
    options.gridSpacing = 1;
end
if ~isfield(options, 'lineWidth')
    options.lineWidth = 1;
end
if ~isfield(options, 'showInterval')
    options.showInterval = false;
end
if ~isfield(options, 'drawGrid')
    options.drawGrid = true;
end
if ~isfield(options, 'drawRefAxis')
    options.drawRefAxis = true;
end
if ~isfield(options, 'edgeWidth')
    options.edgeWidth = 2;
end
if ~isfield(options, 'refLineWidth')
    options.refLineWidth = 3;
end
if ~isfield(options, 'refArrowWidth')
    options.refArrowWidth = 0.05;
end

% Set options
directed = options.directed;
plotWidth = options.plotWidth;
plotScale = options.plotScale;
gridSpacing = options.gridSpacing;
lineWidth = options.lineWidth;
showInterval = options.showInterval;
drawGrid = options.drawGrid;
drawRefAxis = options.drawRefAxis;
edgeWidth = options.edgeWidth;
refLineWidth = options.refLineWidth;
refArrowWidth = options.refArrowWidth;

% Set default figure parameters
if ~exist('h', 'var')
    figure;
    h = gca;  
    set(gca, 'Position', [0.05 0.05 0.9 0.9]);
    set(gca, 'Visible', 'off');
    set(gcf, 'Color', 'w');
    colormap jet;
end

X = reshape(X, 2, 1);
Y = reshape(Y, 2, 1);

% Normalize direction so arrows are on the left
if X(2) < X(1)
    X = flipud(X);
    Y = flipud(Y);
    Atemp = A1;
    A1 = A2;
    A2 = Atemp;
end

axes(h);

% Draw both directions independently
for direction = 1:2

    A = A1;
    if direction == 2 && directed
        A = A2;
    end
    
    if isempty(A)
        continue;
    end
    
    if ~directed
        % Divide edge area by two for mirroring
        A = A / 2;
    end
    
    N = size(A,2)/2;    % Number of functions
    M = 100;            % Plot resolution
    F = zeros(N,M);

    % Compute size of bounding box
    plotSize = ceil(max(A(:))/gridSpacing)*gridSpacing;
    plotHeight = plotSize*plotScale;

    % Compute cumulative functions
    for i = 1:N
        F(i,:) = fuzzy_cumsum(A(:,(i-1)*2+1:(i-1)*2+2),M)';
    end

    % Mirror the computed functions
    F = [F, fliplr(F(:,1:(end-1)))];

    % Compute translation
    Tx = X(1) + (X(2)-X(1))/2;
    Ty = Y(1) + (Y(2)-Y(1))/2;

    % Compute rotation
    theta = atan2(Y(2)-Y(1), X(2)- X(1));

    % Create projection matrix
    if direction == 1
        P = [plotWidth*cos(theta), -sin(theta), Tx; ...
             plotWidth*sin(theta),  cos(theta), Ty; ...
             0, 0, 1];
    else
        P = [-plotWidth*cos(theta), sin(theta), Tx; ...
             -plotWidth*sin(theta), -cos(theta), Ty; ...
             0, 0, 1];
    end

    hold on;

    % Define horizontal grid lines
    Nhoriz = length(0:gridSpacing:plotSize);
    Xhoriz = reshape([-0.5*ones(1,Nhoriz); 0.5*ones(1,Nhoriz); nan(1, Nhoriz)], 1, []);
    Yhoriz = reshape([0:gridSpacing:plotSize; 0:gridSpacing:plotSize; nan(1, Nhoriz)], 1, []) * plotScale;

    % Define vertical grid lines
    Nvert = N+1;
    Xvert = reshape([-0.5:1/N:0.5; -0.5:1/N:0.5; nan(1, Nvert)], 1, []);
    Yvert = reshape([zeros(1,Nvert); plotHeight*ones(1,Nvert); nan(1, Nvert)], 1, []);

    % Move to edge
    Phoriz = P*[Xhoriz; Yhoriz; ones(1,length(Xhoriz))];
    Pvert = P*[Xvert; Yvert; ones(1,length(Xvert))];

    if drawGrid
        % Draw grid
        patch(Phoriz(1,:), Phoriz(2,:), [0.5 0.5 0.5], 'EdgeColor', [0.5 0.5 0.5], 'EdgeAlpha', 0.5);
        patch(Pvert(1,:), Pvert(2,:), [0.5 0.5 0.5], 'EdgeColor', [0.5 0.5 0.5], 'EdgeAlpha', 0.5);
    end

    % Draw functions
    for f = 1:N

        i = f;  
        if direction == 2
            i = N-f+1;
        end
        
        Fmin = -0.5 + (f-1)/N;
        Fmax = -0.5 + f/N;

        % Define max function line
        Xmax = [Fmin, Fmin, Fmax, Fmax];
        Ymax = [0, max(F(i,:)), max(F(i,:)), 0] * plotScale;

        % Define main function line
        Xmain = [Fmin, Fmin + (0:1/(2*M-2):1)/N, Fmax];
        Ymain = [0, F(i,:), 0] * plotScale;

        % Define min function line
        Xmin = [Fmin, Fmin, Fmax, Fmax];
        Ymin = [0, min(F(i,:)), min(F(i,:)), 0] * plotScale;

        % Move to edge
        Pmax = P*[Xmax; Ymax; ones(1,length(Xmax))];
        Pmain = P*[Xmain; Ymain; ones(1,length(Xmain))];
        Pmin = P*[Xmin; Ymin; ones(1,length(Xmin))];

        %Draw functions
        if showInterval
            patch(Pmax(1,:), Pmax(2,:), i, 'FaceAlpha', 0.25, 'LineWidth', lineWidth);
            patch(Pmain(1,:), Pmain(2,:), i, 'FaceAlpha', 0.5, 'LineWidth', lineWidth);
            patch(Pmin(1,:), Pmin(2,:), i, 'LineWidth', lineWidth);
        else
            patch(Pmain(1,:), Pmain(2,:), i, 'FaceAlpha', 1, 'LineWidth', lineWidth);
        end

    end

    if drawRefAxis
        if directed
            % Create directional arrows  
            if direction == 1
                Xref = [-0.5, -0.5, -0.5-refArrowWidth, -0.5-refArrowWidth];
                Yref = [0, plotHeight, plotHeight, 0];
                Pref = P*[Xref; Yref; ones(1,length(Xref))];
                patch(Pref(1,:), Pref(2,:), [0.75 0.75 0.75], 'EdgeColor', [0.75 0.75 0.75]);

                Xref = [-0.5-refArrowWidth, -0.5-refArrowWidth, -0.5];
                Yref = [0, plotHeight, plotHeight/2];
                Pref = P*[Xref; Yref; ones(1,length(Xref))];
                patch(Pref(1,:), Pref(2,:), [0 0 0], 'EdgeColor', [0 0 0]);

            else

                Xref = [0.5, 0.5, 0.5+refArrowWidth, 0.5+refArrowWidth];
                Yref = [0, plotHeight, plotHeight, 0];
                Pref = P*[Xref; Yref; ones(1,length(Xref))];
                patch(Pref(1,:), Pref(2,:), [0.75 0.75 0.75], 'EdgeColor', [0.75 0.75 0.75]);

                Xref = [0.5, 0.5, 0.5+refArrowWidth];
                Yref = [0, plotHeight, plotHeight/2];
                Pref = P*[Xref; Yref; ones(1,length(Xref))];
                patch(Pref(1,:), Pref(2,:), [0 0 0], 'EdgeColor', [0 0 0]);
            end
        else
             % Create thick reference line
            if direction == 1
                Xref = [-0.5, -0.5];
            else
                Xref = [0.5, 0.5];
            end
            Yref = [0, plotHeight];
            Pref = P*[Xref; Yref; ones(1,length(Xref))];
            line(Pref(1,:), Pref(2,:), 'Color', [0 0 0], 'LineWidth', refLineWidth);
        end
    end

end

% Draw edge line
line(X, Y, 'Color', [0 0 0], 'LineWidth', edgeWidth);

hold off;
axis equal;
drawnow;

end
