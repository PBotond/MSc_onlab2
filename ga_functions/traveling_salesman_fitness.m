function scores = traveling_salesman_fitness(x,distances,free_cells)

global maxscores;
global minscores;
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
minscores = [minscores; max(scores)];