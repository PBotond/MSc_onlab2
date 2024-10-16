%%
newMap = true;
randomMap = true;
randomSeed = 10;
mapHeight = 10;
mapWidth = 10;

if (~randomMap)
    rng(randomSeed,"twister");
end
if newMap
    omap = create_map(mapHeight, mapWidth, 2, 4);
end

omx = double(occupancyMatrix(omap));
free_count = mapHeight*mapWidth - sum(sum(omx));
free_cells = zeros(free_count,2);

n = 1;
for i = 1:mapWidth
    for j = 1:mapHeight
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

%% Customizing the Genetic Algorithm for a Custom Data Type
type create_permutations.m
type crossover_permutation.m
type mutate_permutation.m
type traveling_salesman_fitness.m

FitnessFcn = @(x) traveling_salesman_fitness(x,distances,free_cells);

type traveling_salesman_plot.m
my_plot = @(options,state,flag) traveling_salesman_plot(options, ...
    state,flag,free_cells);

options = optimoptions(@ga, 'PopulationType', 'custom','InitialPopulationRange', ...
                            [1;free_count]);
options = optimoptions(options,'CreationFcn',@create_permutations, ...
                        'CrossoverFcn',@crossover_permutation, ...
                        'MutationFcn',@mutate_permutation, ...
                        'PlotFcn', my_plot, ...
                        'MaxGenerations',1000,'PopulationSize',60, ...
                        'MaxStallGenerations',200,'UseVectorized',true);
%%
% Finally, we call the genetic algorithm with our problem information.

numberOfVariables = free_count;
[x,fval,reason,output] = ...
    ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options)

%%
path_cells = x{1};
