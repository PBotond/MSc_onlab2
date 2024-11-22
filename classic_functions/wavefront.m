function [wf] = wavefront(omx, goalXY)
%% Run a wavefront through an occupancy matrix

cX = goalXY(1,1);
cY = goalXY(1,2);

step = 0;
while(isnan(omx(cX, cY)) && step < numel(omx))
    % find next non nan cell in matrix
    if(cX + 1 <= width(omx))
        cX = cX + 1;
        step = step+1;
    else
        cX = 1;
        if(cY + 1 <= height(omx))
            cY = cY + 1;
            step = step+1;
        else
            cY = 1;
            step = step+1;
        end
    end
end

dist = 1;
omx(cX, cY) = dist;
wf = propagateWf(omx, cX, cY, dist);

end

%%

function [wf] = propagateWf(omx, cX, cY, dist)
nbrs = [cX-1, cY; cX+1, cY; cX, cY-1; cX, cY+1];

for i = 1:4
    if(nbrs(i,1) <= height(omx) && nbrs(i,1) > 0 && nbrs(i,2) <= width(omx) && nbrs(i,2) > 0)
        if(omx(nbrs(i,1), nbrs(i,2)) == 0 || omx(nbrs(i,1), nbrs(i,2)) > dist+1)
            omx(nbrs(i,1), nbrs(i,2)) = dist+1;
            omx = propagateWf(omx, nbrs(i,1), nbrs(i,2), dist+1);
        end
    end
end
wf = omx;

end