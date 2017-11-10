function [A, TRI] = delaunay_graph(X, Y)
% DELAUNAY_GRAPH Creates a graph from a Delaunay triangulation.
%
% A = delaunay_graph(X, Y) returns the sparse adjacency matrix A of the
% Delaunay triangulation of the set of points specified by the vectors X
% and Y.
%
% [A, TRI] = delaunay_graph(X, Y) also returns the triangles computed by
% the delaunay triangulation.
%
% Example:
%   [X, Y] = random_separated_points([0 10 0 10], 1);
%   A = delaunay_graph(X, Y);
%   gplot(A, [X, Y], '-o');

% Andrew Buck
% Copyright, University of Missouri, 2014

%% History
%  2014-05-14: Initial coding
%  2015-01-14: Cleanup
%%

assert(length(X) == length(Y));
N = length(X);

TRI = delaunay(X, Y);

A = zeros(N);

for i = 1:size(TRI,1)
    A(TRI(i,1), TRI(i,2)) = 1;
    A(TRI(i,1), TRI(i,3)) = 1;
    A(TRI(i,2), TRI(i,1)) = 1;
    A(TRI(i,2), TRI(i,3)) = 1;
    A(TRI(i,3), TRI(i,1)) = 1;
    A(TRI(i,3), TRI(i,2)) = 1;
end

A = sparse(A);

end
