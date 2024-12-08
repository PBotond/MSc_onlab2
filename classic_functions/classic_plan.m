function [path, wf] = classic_plan(omap, omx, cp_params)

% Calculate distance transform
dt = bwdist(omx);
dt(dt>4) = NaN;
dt(dt==0) = NaN;
dt = 4 -dt;
dt = round(dt);
dt(isnan(dt)) = 0;
dt = dt.^(2);

omx(omx==1) = nan;

% Calculate path transform
wf = pathtransform(omx, cp_params.startXY, dt);

% Check for inaccessible cells
if min(min(wf)) == 0
    disp("Bad map");
    path = NaN;
    return;
end

% Path planning
[path, ~] = iterPlan2(wf, [height(omx), width(omx)], omap, omx);


end

