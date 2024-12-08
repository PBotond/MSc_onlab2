%% Reset
clc;
close all;

%% Set map parameters
cp_params.newMap = true;
cp_params.randomMap = true;
cp_params.randomSeed = 10;
cp_params.startXY = [1 1];


cp_params.mapHeightY = 10;
cp_params.mapWidthX = 10;
cp_params.numberOfObstacles = 2;
cp_params.obstacleMaxSize = 2;

global maxscores
maxscores = [];

%% Generate map
if (~cp_params.randomMap)
    rng(cp_params.randomSeed,"twister");
end
if cp_params.newMap || ~exist('omap', 'var')
    omap = create_map(cp_params.mapHeightY, cp_params.mapWidthX, cp_params.obstacleMaxSize, cp_params.numberOfObstacles);
end


% Store map in matrix
omx = double(occupancyMatrix(omap));

%% Classic planning
[classic_path, classic_wf] = classic_plan(omap, omx, cp_params);
[ga_path, free_cells, distances] = ga_plan(omap, omx, cp_params);
classic_score = classic_fitness(free_cells, classic_path, distances);
%% Plots
single_plot(classic_wf, omx, classic_path);
single_plot(classic_wf, omx, ga_path);
fitness_plot(maxscores);