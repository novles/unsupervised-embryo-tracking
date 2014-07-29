function [radius dist] = findRadius(x1, y1, x2, y2, angle)

    dist = sqrt((x1-x2)^2 + (y1-y2)^2);
    adj = tan(angle)*(dist/2);
    radius = sqrt((dist/2)^2 + adj^2);

end