function [omap] = create_map(mapHeightY, mapWidthX, obstacleMaxSize, numberOfObstacles)
%CREATE_MAP Create occupancy map with paramters
% Create the binary occupancy map object
omap = binaryOccupancyMap(mapWidthX, mapHeightY);

% Generate obstacles
obstacleNumber = 1;
while obstacleNumber <= numberOfObstacles
    width = randi([1 obstacleMaxSize],1);
    length = randi([1 obstacleMaxSize],1);
    xPosition = randi([0 mapWidthX-width],1);
    yPosition = randi([0 mapHeightY-length],1);

    [xObstacle,yObstacle] = meshgrid(xPosition:xPosition+width,yPosition:yPosition+length);
    xyObstacles = [xObstacle(:) yObstacle(:)];

    checkIntersection = false;
    for i = 1:size(xyObstacles,1)
        if checkOccupancy(omap,xyObstacles(i,:)) == 1
            checkIntersection = true;
            break
        end
    end
    if checkIntersection
        continue
    end

    setOccupancy(omap,xyObstacles,1)

    obstacleNumber = obstacleNumber + 1;
end
disp("Map generated.")
end

