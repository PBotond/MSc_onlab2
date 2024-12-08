function score = classic_fitness(free_cells, classic_path, distances)
cellids = [];
for i = 1:length(classic_path)
    cellids = [cellids find(ismember(free_cells, classic_path(i, 1:2), 'rows'))];
end
cells{1} = cellids;
score = traveling_salesman_fitness(cells, distances, free_cells);
end