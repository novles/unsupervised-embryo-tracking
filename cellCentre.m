% takes an image and a guess at where the circle is, spits out a better
% guess. I guess.

function [rad x y] = cellCentre(in, x, y)
    
    cellCentre = [firstEst(3) firstEst(4)];
    cellTopC = cellCentre-floor(sizeEst/2);


    search = cell(1,2);

    botY = floor(size(searchArea,1)/2);
    topY = ceil(size(searchArea,1)/2);
    search{1} = searchArea(1:botY,:);
    search{2} = searchArea(topY+1:end,:);

    circleX = 0;
    circleY = 0;

    for i = 0:1

        index = i+1;
        kern = gabor_patch(gaborStd, i*pi/2+pi/4, gaborLambda, 0, .1,64).^2; % Approximates a straight bit

        y =  kernFind(kern,in);

        circleX(index) = y(2);
        circleY(index) = y(1);

    end
    

    [rad opp adj] = findRadius(circleX(1),circleX(1),circleY(1),circleY(1),pi/2);
    
    
    
end






