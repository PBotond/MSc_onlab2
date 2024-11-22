function [path, visited] = iterPlan2(wf, startXY, omap, omx)
%PLANNER Plan path on occupancy matrix
cX = startXY(1,1);
cY = startXY(1,2);

step=0;
% find closest non nan cell to startXY
while((isnan(wf(cX, cY)) || wf(cX,cY) == 0) && step < numel(wf))
    if(cX - 1 >= 1)
        cX = cX - 1;
        step = step+1;
    else
        cX = height(wf);
        if(cY - 1 >= 1)
            cY = cY - 1;
            step = step+1;
        else
            cY = width(wf);
            step = step+1;
        end
    end
end

visited = double(isnan(wf)); % keep track of visited cells and number of visits
visited(visited == 1) = inf;
path = []; % coordinates of each cell visited
dir = [-1, 0]; % initial direction - could be anything
looping = true;
planner = plannerAStarGrid(omap);
planner.DiagonalSearch = 'off';

while(looping)
    visited(cX, cY) = visited(cX, cY) + 1;
    path = [path; [cX, cY, 0]];
    dir = findMaxNbrDT(wf, visited, [cX, cY], dir);
    
    if isnan(dir)
        localWf = wavefront(omx, [cX cY]);
        for j=1:height(path)
            localWf(path(j,1), path(j,2)) = inf;
        end
        localWf(localWf == 0) = inf;
        minVal = min(min(localWf));
        if (minVal) == inf
            looping = false;
            break;
        end
        [cXnew, cYnew] = find(localWf==minVal);
        cXnew = cXnew(1,1);
        cYnew = cYnew(1,1);
        planned = plan(planner, [cX cY], [cXnew cYnew]);
        path(end,:) = [];
        planned(end,:) = [];
        for j=1:length(planned)
            visited(planned(j,1), planned(j,2)) = visited(planned(j,1), planned(j,2)) + 1;
        end
        path = [path; planned, ones(length(planned),1)];
        dir = path(end-1, 1:2) - path(end, 1:2);
        cX = cXnew;
        cY = cYnew;
    else
        cX = cX + dir(1);
        cY = cY + dir(2);
    end
end

end
%%

function nextDir = findMaxNbrDT(wf, visited, XY, prevDir)
% Define 4-connected neighbourhood
directions = [-1, 0; 1, 0; 0, -1; 0, 1];
if(~isnan(prevDir))
    directions = [prevDir; directions];
end
maxDT = -inf;
nextDir = NaN;

% Check all neighbours
for i = 1:length(directions)
    nextXY = XY + directions(i, :);
    
    % Check if next cell is within grid and not visited
    if nextXY(1) >= 1 && nextXY(1) <= size(wf, 1) && nextXY(2) >= 1 && nextXY(2) <= size(wf, 2) && ~visited(nextXY(1), nextXY(2))
        % Check if next cell has a higher distance transform
        if wf(nextXY(1), nextXY(2)) > maxDT
            nextDir = directions(i,:);
            maxDT = wf(nextXY(1), nextXY(2));
        end
    end
end

end