%% Reset
clc;
close all;
clear all;

%% Set map parameters
iter = 1;
gawin = 0;
data_max = {};
cp_params.startXY = [1 1];
cp_params.mapHeightY = 7;
cp_params.mapWidthX = 7;
cp_params.numberOfObstacles = 3;
cp_params.obstacleMaxSize = 1;
global maxscores
gatimes = [];
classictimes = [];
while(height(data_max)<100)
    disp(iter);
    maxscores = [];
    iter = iter+1;
    cp_params.randomSeed = iter;
    rng(cp_params.randomSeed,"twister");
    omap = create_map(cp_params.mapHeightY, cp_params.mapWidthX, cp_params.obstacleMaxSize, cp_params.numberOfObstacles);
    omx = double(occupancyMatrix(omap));
    tic;
    [classic_path, classic_wf] = classic_plan(omap, omx, cp_params);
    if(~isnan(classic_path))
        classictimes = [classictimes; toc];

        tic;
        [ga_path, free_cells, distances] = ga_plan(omap, omx, cp_params);
        gatimes = [gatimes; toc];
        gascore = min(maxscores)
        classic_score = classic_fitness(free_cells, classic_path, distances);
        data_max = [data_max; maxscores];
        if(gascore < classic_score)
            gawin = gawin+1;
        end
    end
end

%%
cscores = [];
for(i=1:height(data_max))
    cscores = [cscores; data_max{i}(end)];
    data_max{i} = data_max{i}(1:end-1);
end

%%
maxLength = max(cellfun(@length, data_max));
maxValues = inf(1, maxLength);
minValues = -inf(1, maxLength);
valuesMatrix = nan(length(data_max), maxLength);

for i = 1:height(data_max)
    vector = data_max{i};
    for j = 1:length(vector)
        maxValues(j) = min(maxValues(j), vector(j));
        minValues(j) = max(maxValues(j), vector(j));
    end
    valuesMatrix(i, 1:length(vector)) = vector;
end
medianValues = median(valuesMatrix, 1, "omitmissing");

%%
figure();
hold on;
plot(minValues, 'b--');
plot(medianValues, 'c');
plot(maxValues, 'b--');
yline(min(cscores), 'r--');
yline(max(cscores), 'r--');
yline(median(cscores), 'r');
grid on;
xlim([0 maxLength]);
xlabel("Generáció száma");
ylabel("Fitness-érték");

%%
disp(min(classictimes))
disp(median(classictimes))
disp(max(classictimes))

disp(min(gatimes))
disp(median(gatimes))
disp(max(gatimes))
