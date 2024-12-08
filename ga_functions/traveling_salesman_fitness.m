function scores = traveling_salesman_fitness(x,distances,free_cells)
%TRAVELING_SALESMAN_FITNESS  Custom fitness function for TSP. 
%   SCORES = TRAVELING_SALESMAN_FITNESS(X,DISTANCES) Calculate the fitness 
%   of an individual. The fitness is the total distance traveled for an
%   ordered set of cities in X. DISTANCE(A,B) is the distance from the city
%   A to the city B.

%   Copyright 2004-2007 The MathWorks, Inc.
global maxscores;
scores = zeros(size(x,1),1);
for j = 1:size(x,1)
    % here is where the special knowledge that the population is a cell
    % array is used. Normally, this would be pop(j,:);
    p = x{j}; 
    %f = distances(p(end),p(1));
    f = 0;
    for i = 2:length(p)-1
        f = f + distances(p(i-1),p(i));
        x_prev = free_cells(p(i-1), 1);
        y_prev = free_cells(p(i-1), 2);
        x_curr = free_cells(p(i), 1);
        y_curr = free_cells(p(i), 2);
        x_next = free_cells(p(i+1), 1);
        y_next = free_cells(p(i+1), 2);
        if (prod([x_curr y_curr] - [x_prev y_prev] == [x_next y_next] - [x_curr y_curr]) ~= 1)
            f= f+2;
        end
    end
    f = f + distances(p(end-1), p(end));
    scores(j) = f;
end
maxscores = [maxscores; min(scores)];