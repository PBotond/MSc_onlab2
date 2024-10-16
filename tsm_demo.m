%%
newMap = true;
randomMap = true;
randomSeed = 10;

if (~randomMap)
    rng(randomSeed,"twister");
end
if newMap
    omap = create_map(10, 10, 2, 4);
end

omx = double(occupancyMatrix(omap));
freecells = height(omx)*width(omx) - sum(sum(omx));
%% Customizing the Genetic Algorithm for a Custom Data Type
type create_permutations.m
type crossover_permutation.m
type mutate_permutation.m
type traveling_salesman_fitness.m

FitnessFcn = @(x) traveling_salesman_fitness(x,distances);

type traveling_salesman_plot.m
my_plot = @(options,state,flag) traveling_salesman_plot(options, ...
    state,flag,locations);

options = optimoptions(@ga, 'PopulationType', 'custom','InitialPopulationRange', ...
                            [1;freecells]);
options = optimoptions(options,'CreationFcn',@create_permutations, ...
                        'CrossoverFcn',@crossover_permutation, ...
                        'MutationFcn',@mutate_permutation, ...
                        'PlotFcn', my_plot, ...
                        'MaxGenerations',500,'PopulationSize',60, ...
                        'MaxStallGenerations',200,'UseVectorized',true);
%%
% Finally, we call the genetic algorithm with our problem information.

numberOfVariables = freecells;
[x,fval,reason,output] = ...
    ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options)

%%
% The plot shows the location of the cities in blue circles as well as the
% path found by the genetic algorithm that the salesman will travel. The
% salesman can  start at either end of the route and at the end, return to
% the starting city to get back home.
