function y = normalize(x, uBound, lBound)

    switch nargin
        case 1
            lBound = 0;
            uBound = 1;
        case 2
            lBound = 0;
    end
    
    
    xSize = size(x,2);
    ySize = size(x,1);
    
    x_ = zeros([size(x,2) size(x,1)]);
    
    for i = 1:ySize
       for j = 1:xSize 
           if abs(x(i,j)) ~= inf
               x_(i,j) = x(i,j);
           end
       end
    end
    
    xMin = min(x_(:));
    xMax = max(x_(:));
    
    scaleFactor = abs(1/(xMax - xMin));

    y = (x-(xMin+xMax)/2).*abs(uBound-lBound)*scaleFactor + (lBound + uBound)/2;
    
%    y = (x-min(x(:))) ./ (max(x(:)-min(x(:))));
end