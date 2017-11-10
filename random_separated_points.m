function [X, Y] = random_separated_points(bbox, sep)
% RANDOM_SEPARATED_POINTS Generates a random set of points with a minimum
% separation between points.
%
% [X, Y] = random_separated_points(bbox, sep) returns the X and Y vectors
% for a set of randomly sampled points in the bounding box specified by 
% bbox=[xmin xmax ymin ymax] with a minimum separation specified by sep.
%
% This function will continue to place points randomly until there are 100
% failed attempts to add a new point with the minimum required separation.
%
% Example:
%   [X, Y] = random_separated_points([0 10 0 10], 1);
%   scatter(X,Y);

% Andrew Buck
% Copyright, University of Missouri, 2014

%% History
%  2014-05-14: Initial coding
%  2015-01-14: Cleanup
%%

MAX_TRIES = 100;

X = [];
Y = [];

noMoreRoom = false;
while ~noMoreRoom
   
    tries = 0;
    while tries < MAX_TRIES
        
        % Get a test point
        x = rand*(bbox(2)-bbox(1)) + bbox(1);
        y = rand*(bbox(4)-bbox(3)) + bbox(3);
        
        % Check if it is far enough away from the other points
        valid = true;
        for i = 1:size(X,1)
            if sqrt((x-X(i))^2 + (y-Y(i))^2) < sep
                valid = false;
                break;
            end
        end
        
        % Add point if valid
        if valid
            X = [X; x];
            Y = [Y; y];
            break;
        else
            tries = tries + 1;
        end
        
    end
    
    if tries == MAX_TRIES
        noMoreRoom = true;
    end
    
end

end
