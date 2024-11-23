function fitness_plot(maxscores)
    figure();
    hold on;
    plot(maxscores(1:end-1));
    yline(maxscores(end));
end