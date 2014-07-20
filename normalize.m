function y = normalize(x, uBound, lBound)

    switch nargin
        case 1
            lBound = 0;
            uBound = 1;
        case 2
            lBound = 0;
    end

    xMin = min(x(:));
    xMax = max(x(:));
    
    scaleFactor = 1/(xMax - xMin);

    y = (((x-xMin)*(uBound-lBound)*scaleFactor) - (uBound-lBound)/2) + (uBound+lBound)/2;
    
%    y = (x-min(x(:))) ./ (max(x(:)-min(x(:))));
end