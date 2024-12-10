function state = traveling_salesman_plot(options,state,flag,locations)
persistent x y

clf;
plot(x,y,'Color','red');
axis("auto");

hold on;
[unused,i] = min(state.Score);
genotype = state.Population{i};

plot(locations(:,1),locations(:,2),'bo');
plot(locations(genotype,1),locations(genotype,2));
hold off
