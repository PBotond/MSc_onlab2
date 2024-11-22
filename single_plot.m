function single_plot(wf, omx, path)
    fig = figure();
    hm = heatmap(fig, wf);
    s=struct(hm);
    s.XAxis.Visible='off';
    s.YAxis.Visible='off';
    hm.ColorbarVisible = false;
    hm.NodeChildren(3).YDir='normal';
    ax = axes;
    line([0,0],[height(omx), width(omx)]);
    line( [height(omx), width(omx)], [0,0]);
    hold on
    for i=1:length(path)-1
        if path(i, 3) == 1
            quiver(ax, path(i,2)-0.65, path(i,1)-0.65, path(i+1,2)-path(i,2), path(i+1,1)-path(i,1),0.8,'m-','LineWidth', 2,'MaxHeadSize','5');
        else
            quiver(ax, path(i,2)-0.5, path(i,1)-0.5, path(i+1,2)-path(i,2), path(i+1,1)-path(i,1),0.8,'y','LineWidth', 2,'MaxHeadSize','5');
        end
    end
    plot(path(1,2)-0.5, path(1,1)-0.5, 'go', 'MarkerSize', 20, 'LineWidth', 2);
    plot(path(end,2)-0.5, path(end,1)-0.5, 'ro', 'MarkerSize', 20, 'LineWidth', 2);

    hold off
    ax.YLim = [0,height(wf)];
    ax.XLim = [0, width(wf)];
    ax.Color = 'none';
    ax.XTick = [];
    ax.YTick = [];
    fontname("Times New Roman");

    set (gca,'Position',[0 0 1 1]);
    hm.InnerPosition = [0 0 1 1];
end