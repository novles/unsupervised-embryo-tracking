function out = makeGabFilt(gaborStd, gaborLambda, gaborAspect, nPatches, imSizeX, imSizeY, phi, isCell)
    

    switch nargin
        case 0
            gaborStd = pi;
            gaborLambda = gaborStd*2;
            gaborAspect = 1;
            nPatches = 8;
            imSizeX = 480;
            imSizeY = 480;
            phi = 0;
            isCell = false;
        case 1
            gaborLambda = gaborStd*2;
            gaborAspect = 1;
            nPatches = 8;
            imSizeX = 480;
            imSizeY = 480;
            phi = 0;
            isCell = false;
        case 2
            gaborAspect = 1;
            nPatches = 8;
            imSizeX = 480;
            imSizeY = 480;
            phi = 0;
            isCell = false;
        case 3
            nPatches = 8;
            imSizeX = 480;
            imSizeY = 480;
            phi = 0;
            isCell = false;
        case 4
            imSizeX = 480;
            imSizeY = 480;
            phi = 0;
            isCell = false;
        case 5
            imSizeY = imSizeX;
            phi = 0;
            isCell = false;
        case 6
            phi = 0;
            isCell = false;
        case 7
            isCell = false;
    end
    
    if isCell == false
        
        gabFilt = 0;

        for i = 1:nPatches
            gabbaba = gabor_patch(gaborStd, (i-1)*pi/nPatches, gaborLambda, phi, gaborAspect, imSizeX,imSizeY);
            gabFilt = gabFilt + fft2(gabbaba);
        end

        out = gabFilt;
        
    else
    
        gabFilt = cell(1,nPatches+1);
        gabFilt{nPatches+1} = 0;

        for i = 1:nPatches
            gabbaba = gabor_patch(gaborStd, (i-1)*pi/nPatches, gaborLambda, phi, gaborAspect, imSizeX,imSizeY);
            gabFilt{i} = fft2(gabbaba);
            gabFilt{nPatches+1} = gabFilt{nPatches+1} + gabFilt{i};
        end
        
        
        out = gabFilt;
    
        
    
end