function out = makeGabFilt(gaborStd, gaborLambda, gaborAspect, nPatches, imSizeX, imSizeY)
    

    switch nargin
        case 0
            gaborStd = pi;
            gaborLambda = gaborStd*2;
            gaborAspect = 1;
            nPatches = 8;
            imSizeX = 480;
            imSizeY = 480;
        case 1
            gaborLambda = gaborStd*2;
            gaborAspect = 1;
            nPatches = 8;
            imSizeX = 480;
            imSizeY = 480;
        case 2
            gaborAspect = 1;
            nPatches = 8;
            imSizeX = 480;
            imSizeY = 480;
        case 3
            nPatches = 8;
            imSizeX = 480;
            imSizeY = 480;
        case 4
            imSizeY = imSizeX;
        case 5;
    end
            
    gabFilt = 0;

    for i = 1:nPatches
        gabbaba = gabor_patch(gaborStd, (i-1)*pi/nPatches, gaborLambda, 0, gaborAspect, imSizeX,imSizeY);
        gabFilt = gabFilt + fft2(gabbaba);
    end
    
    
    out = gabFilt;
    
end