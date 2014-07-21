function loc = kernFind(kern, in)
    
    xCorr = normxcorr2(kern,in);
    [maxVal, index] = max(xCorr(:));

    [yPeak, xPeak] = ind2sub(size(xCorr),index(1));

    xOffset = xPeak - size(kern,2)/2 + 1;
    yOffset = yPeak - size(kern,1)/2 + 1;

    figure;
    imshow(normalize(in));
    hold on;
    plot(xOffset, yOffset,'o','MarkerSize',10);
    hold off;
    loc = [xOffset yOffset maxVal];

end




