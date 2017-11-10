function C = fuzzy_cumsum(X, M)
% FUZZY_CUMSUM Computes the inverse normalized cumulative function of a
% fuzzy number in interval notation.
%
% C = fuzzy_cumsum(X, M) returns the inverse normalized cumulative function
% of the fuzzy number X, defined on an evenly spaced domain of M points.
%
% Example:
%   X = fuzzy_trimf(1,2,3);
%   C = fuzzy_cumsum(X, 100);

% Andrew Buck
% Copyright, University of Missouri, 2015

%% History
%  2014-06-12: Initial coding
%  2015-01-16: Cleanup
%%

% Number of alpha cuts
N = size(X,1);

% Get known function points
x = [X(:,1); flipud(X(:,2))];
y = [(0:1/(N-1):1)'; (1:-1/(N-1):0)'];

% Total area
A = fuzzy_area(X);

% Initialize output
C = zeros(M,1);

C(1) = X(1);
s = 0; % Amount of area gathered so far
Xi = 1; % Input function index
for i = 2:M
    
    % Amount of area needed at this point in the output
    t = (i-1)/(M-1)*A;
    
    while s < t && Xi < 2*N
    
        % Compute area gained by adding next function point
        a = (y(Xi) + y(Xi+1))/2 * (x(Xi+1) - x(Xi));
        s = s + a;
        
        Xi = Xi + 1;
    end
    
    if s > t
        x1 = x(Xi-1);
        y1 = y(Xi-1);
        x2 = x(Xi);
        y2 = y(Xi);
        if y2-y1 == 0
            C(i) = x2 - (s-t)/y1;
        else
            alpha = (sqrt((x2-x1)*(-2*s*y2+2*s*y1+2*t*y2-2*t*y1-x1*y2^2+x2*y2^2))+x1*y1-x2*y1)/((x2-x1)*(y2-y1));
            C(i) = alpha*x2 + (1-alpha)*x1;
        end
    else
        C(i) = x(Xi);
    end
    
end

end
