function A = urquhart_graph(X, Y)
% URQUHART_GRAPH Creates the Urquhart graph from a set of points.
%
% The Urquhart graph of a set of points is obtained by removing the longest
% edge from each triangle in the Delaunay triangulation.
%
% See http://en.wikipedia.org/wiki/Urquhart_graph for information on
% Urquhart graphs.
%
% A = urquhart_graph(X, Y) returns the sparse adjacency matrix A for the 
% Urquhart graph of the set of points specified by the vectors X and Y.
%
% Example:
%   [X, Y] = random_separated_points([0 10 0 10], 1);
%   A = urquhart_graph(X, Y);
%   gplot(A, [X, Y], '-o');

% Andrew Buck
% Copyright, University of Missouri, 2014

%% History
%  2014-05-14: Initial coding
%  2015-01-14: Cleanup
%%

[A, TRI] = delaunay_graph(X, Y);
A = full(A);

for i = 1:size(TRI,1)
    
    % Get edge lengths
    d1 = sqrt((X(TRI(i,1)) - X(TRI(i,2)))^2 + (Y(TRI(i,1)) - Y(TRI(i,2)))^2);
    d2 = sqrt((X(TRI(i,2)) - X(TRI(i,3)))^2 + (Y(TRI(i,2)) - Y(TRI(i,3)))^2);
    d3 = sqrt((X(TRI(i,3)) - X(TRI(i,1)))^2 + (Y(TRI(i,3)) - Y(TRI(i,1)))^2);
    
    % Remove edge 1 if it is the longest
    if d1 > d2 && d1 > d3
        A(TRI(i,1),TRI(i,2)) = 0;
        A(TRI(i,2),TRI(i,1)) = 0;
    end
    
    % Remove edge 2 if it is the longest
    if d2 > d1 && d2 > d3
        A(TRI(i,2),TRI(i,3)) = 0;
        A(TRI(i,3),TRI(i,2)) = 0;
    end
    
    % Remove edge 3 if it is the longest
    if d3 > d1 && d3 > d2
        A(TRI(i,3),TRI(i,1)) = 0;
        A(TRI(i,1),TRI(i,3)) = 0;
    end
end

A = sparse(A);

end
