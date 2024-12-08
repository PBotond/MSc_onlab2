function [omap] = create_map(mapHeightY, mapWidthX, obstacleMaxSize, numberOfObstacles)
%CREATE_MAP Create occupancy map with paramters
% Create the binary occupancy map object
mapWidthX = mapWidthX;
mapHeightY = mapHeightY;

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
borderxy = [];
for i = 1:mapWidthX
    borderxy = [borderxy; 1 i; mapHeightY i];
end
for i = 1:mapHeightY
    borderxy = [borderxy; i 1; i mapWidthX];
end
setOccupancy(omap, borderxy, 1);

disp("Map generated.")
end

