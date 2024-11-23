function [path, free_cells, distances] = ga_plan(omap, omx, cp_params)

% Count free cells
free_count = cp_params.mapHeightY*cp_params.mapWidthX - sum(sum(omx));
free_cells = zeros(free_count,2);

n = 1;
for i = 1:cp_params.mapWidthX
    for j = 1:cp_params.mapHeightY
        if (omx(i,j) == 0)
            free_cells(n,1) = i;
            free_cells(n, 2) = j;
            n = n+1;
        end
    end
end

%% Calculate all distances
planner = plannerAStarGrid(omap);
planner.DiagonalSearch = 'off';
distances = zeros(free_count);
for i=1:free_count
    for j=1:free_count
        x1 = free_cells(i,1);
        y1 = free_cells(i,2);
        x2 = free_cells(j,1);
        y2 = free_cells(j,2);
        distances(i,j)=length(plan(planner, [x1,y1], [x2,y2]));
        distances(j,i)=distances(i,j);
    end
end

% GA customization
FitnessFcn = @(x) traveling_salesman_fitness(x,distances,free_cells);
my_plot = @(options,state,flag) traveling_salesman_plot(options, ...
    state,flag,free_cells);

options = optimoptions(@ga, 'PopulationType', 'custom','InitialPopulationRange', ...
    [1;free_count]);
options = optimoptions(options,'CreationFcn',@create_permutations, ...
    'CrossoverFcn',@crossover_permutation, ...
    'MutationFcn',@mutate_permutation, ...
    'PlotFcn', my_plot, ...
    'MaxGenerations',700,'PopulationSize',60, ...
    'MaxStallGenerations',200,'UseVectorized',true);

% Run GA
numberOfVariables = free_count;
[x,fval,reason,output] = ...
    ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options)

% Get Path
path_cells = x{1};
path = [];
min_dist = min(min(distances));
j = length(path_cells);
for i = 1 : j-1
    if distances(path_cells(i), path_cells(i+1)) == min_dist
        path = [path; [free_cells(path_cells(i),1) free_cells(path_cells(i),2) 0]];
    else
        planned_path = plan(planner, [free_cells(path_cells(i),1) free_cells(path_cells(i),2)], [free_cells(path_cells(i+1), 1) free_cells(path_cells(i+1), 2)]);
        path = [path; [planned_path ones(length(planned_path), 1)]];
    end
end

if distances(path_cells(j-1), path_cells(j)) == min_dist
    path = [path; [free_cells(path_cells(j),1) free_cells(path_cells(j),2) 0]];
else
    planned_path = plan(planner, [free_cells(path_cells(j-1),1) free_cells(path_cells(j-1),2)], [free_cells(path_cells(j), 1) free_cells(path_cells(j), 2)]);
    path = [path; [planned_path ones(length(planned_path), 1)]];
end



end
