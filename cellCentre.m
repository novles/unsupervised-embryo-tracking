% function loc = cellCentre(inputImage, radius)

if true
    
    startRad = 100;
    cellLevel = 2;
    rad = startRad*nthroot((2^cellLevel),3)
    
    kern = gabCurve(gaborStd, 0, gaborLambda, 0, 1, rad, 195);
    
    xSize = size(result,2);
    ySize = size(result,1);

    xCorr = normxcorr2(kern,result);
    [maxVal, index] = max(xCorr(:));

    [yPeak, xPeak] = ind2sub(size(xCorr),index(1));

    xOffset = xPeak - size(kern,2)/2 + 1;
    yOffset = yPeak - size(kern,1)/2 + 1;

    figure;
    imshow(normalize(result));
    hold on;
    plot(xOffset, yOffset,'o','MarkerSize',10);

end




