function fuzzy_rose_plot(A, options, h)
% FUZZY_ROSE_PLOT Generates a fuzzy rose plot of a vector of fuzzy numbers.
%
% Example:
%   A = fuzzy_randmf_vector(5, 10);
%   fuzzy_rose_plot(A);

% Andrew Buck
% Copyright, University of Missouri, 2015

%% History
%  2014-06-16: Initial coding
%  2015-01-16: Cleanup / Added options
%%

% Create options structure if it is not provided
if ~exist('options', 'var')
    options = struct();
end

% Define default options
if ~isfield(options, 'x')
    options.x = 0;
end
if ~isfield(options, 'y')
    options.y = 0;
end
if ~isfield(options, 'plotScale')
    options.plotScale = 1;
end
if ~isfield(options, 'gridSpacing')
    options.gridSpacing = max(A(:))/5;
end
if ~isfield(options, 'offset')
    options.offset = 0;
end
if ~isfield(options, 'lineWidth')
    options.lineWidth = 2;
end
if ~isfield(options, 'showInterval')
    options.showInterval = true;
end
if ~isfield(options, 'drawGrid')
    options.drawGrid = true;
end
if ~isfield(options, 'colorOffset')
    options.colorOffset = 0;
end

% Set options
x = options.x;
y = options.y;
plotScale = options.plotScale;
gridSpacing = options.gridSpacing;
offset = options.offset;
lineWidth = options.lineWidth;
showInterval = options.showInterval;
drawGrid = options.drawGrid;
colorOffset = options.colorOffset;

% Set default figure parameters
if ~exist('h', 'var')
    figure;
    h = gca;  
    set(gca, 'Position', [0.05 0.05 0.9 0.9]);
    set(gca, 'Visible', 'off');
    set(gcf, 'Color', 'w');
    colormap jet;
end

N = size(A,2)/2;    % Number of petals
M = 100;            % Plot resolution

% Compute theta angles
dF = 2*pi/N;
theta = 0:-dF/(2*M-2):-dF;
Ft = zeros(N,2*M-1);
for i = 1:N
    Ft(i,:) = theta + pi/2 - (i-1)*dF;
end

% Compensate for offset
extraF = (dF*offset^2)/(2*plotScale);
A = A + repmat(extraF, size(A));

% Compute cumulative functions
F = zeros(N,M);
for i = 1:N
    F(i,:) = fuzzy_cumsum(A(:,(i-1)*2+1:(i-1)*2+2),M)';
end

% Mirror the computed functions
F = [F, fliplr(F(:,1:(end-1)))];

% Determine extent of plot
plotSize = ceil(max(A(:)-extraF)/gridSpacing)*gridSpacing;

% Prepare for drawing
axes(h);
hold on;

if drawGrid
    %Draw grid spokes
    t = pi/2:-dF:-3*pi/2+dF;
    for i = 1:length(t)
        x1 = x;
        x2 = x + cos(t(i))*sqrt(2*(plotSize+extraF)*plotScale/dF);
        y1 = y;
        y2 = y + sin(t(i))*sqrt(2*(plotSize+extraF)*plotScale/dF);
        patch([x1 x2], [y1 y2], [0.5 0.5 0.5], 'EdgeColor', [0.5 0.5 0.5], 'EdgeAlpha', 0.5);
    end

    %Draw grid circles
    dt = pi/64;
    t = 0:dt:2*pi;
    r = (0:gridSpacing:plotSize) + extraF;
    for i = 2:length(r);
        for j = 2:length(t)
            x1 = x + cos(t(j-1))*sqrt(2*r(i)*plotScale/dF);
            x2 = x + cos(t(j))*sqrt(2*r(i)*plotScale/dF);
            y1 = y + sin(t(j-1))*sqrt(2*r(i)*plotScale/dF);
            y2 = y + sin(t(j))*sqrt(2*r(i)*plotScale/dF);
            patch([x1 x2], [y1, y2], [0.5 0.5 0.5], 'EdgeColor', [0.5 0.5 0.5], 'EdgeAlpha', 0.5);
        end
    end
end

if showInterval && size(A,1) > 1
    % Draw max arc
    for i = 1:size(F,1)
        X = [cos(Ft(i,:)).*sqrt(2*max(F(i,:))*plotScale/dF), 0] + x;
        Y = [sin(Ft(i,:)).*sqrt(2*max(F(i,:))*plotScale/dF), 0] + y;
        patch(X,Y,colorOffset+i, 'FaceAlpha', 0.25, 'LineWidth', lineWidth);
    end
end

% Draw main function arc
for i = 1:size(F,1)
    X = [cos(Ft(i,:)).*sqrt(2*F(i,:)*plotScale/dF), 0] + x;
    Y = [sin(Ft(i,:)).*sqrt(2*F(i,:)*plotScale/dF), 0] + y;
    if showInterval && size(A,1) > 1
        patch(X,Y,colorOffset+i, 'FaceAlpha', 0.5, 'LineWidth', lineWidth);
    else
        patch(X,Y,colorOffset+i, 'FaceAlpha', 1, 'LineWidth', lineWidth);
    end
end

if showInterval && size(A,1) > 1
    % Draw min arc
    for i = 1:size(F,1)
        X = [cos(Ft(i,:)).*sqrt(2*min(F(i,:))*plotScale/dF), 0] + x;
        Y = [sin(Ft(i,:)).*sqrt(2*min(F(i,:))*plotScale/dF), 0] + y;
        patch(X,Y,colorOffset+i, 'LineWidth', lineWidth);
    end
end

if offset > 0
    % Draw center circle
    t = 0:2*pi/M:2*pi;
    Cx = cos(t)*offset;
    Cy = sin(t)*offset;
    patch(x+Cx, y+Cy, 3*ones(1,length(Cx)), [0.75 0.75 0.75], 'FaceAlpha', 1);
end

% hold off;
axis equal;
drawnow;

end
