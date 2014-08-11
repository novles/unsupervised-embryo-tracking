function out = makeGabCurvFilt(gaborStd, gaborLambda, gaborAspect, nPatches, imSizeX, imSizeY, phi, radius, play, isCell)
    

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
            radius = 100;
            play = 0;
            
        case 1
            gaborLambda = gaborStd*2;
            gaborAspect = 1;
            nPatches = 8;
            imSizeX = 480;
            imSizeY = 480;
            phi = 0;
            isCell = false;
            radius = 100;
            play = 0;
        case 2
            gaborAspect = 1;
            nPatches = 8;
            imSizeX = 480;
            imSizeY = 480;
            phi = 0;
            isCell = false;
            radius = 100;
            play = 0;
        case 3
            nPatches = 8;
            imSizeX = 480;
            imSizeY = 480;
            phi = 0;
            isCell = false;
            radius = 100;
            play = 0;
        case 4
            imSizeX = 480;
            imSizeY = 480;
            phi = 0;
            isCell = false;
            radius = 100;
            play = 0;
        case 5
            imSizeY = imSizeX;
            phi = 0;
            isCell = false;
            radius = 100;
            play = 20;
        case 6
            phi = 0;
            isCell = false;
            radius = 100;
            play = 20;
        case 7
            isCell = false;
            radius = 100;
            play = 20;
        case 8
            play = 20;
            isCell = false;
        case 9
            isCell = false;
    end
    
    gaborStd = gaborStd/(1-2*play);
    
    if isCell == false
        
        gabFilt = 0;

        for i = 1:nPatches
%             gabbaba = gabor_patch(gaborStd, (i-1)*pi/nPatches, gaborLambda, phi, gaborAspect, imSizeX,imSizeY);
            gabbaba = gabCurve(gaborStd,(i-1)*pi/nPatches,gaborLambda, phi, radius, pi/nPatches, gaborAspect, false);
            gabFilt = gabFilt + fft2(gabbaba,imSizeY,imSizeX);
        end

        out = gabFilt;
        
    else
    
        gabFilt = cell(1,nPatches+1);
        gabFilt{nPatches+1} = 0;

        for i = 1:nPatches
            gabbaba = gabCurve(gaborStd,(i-1)*2*pi/nPatches,gaborLambda, phi, radius, 2*pi/nPatches, gaborAspect, false);
            gabFilt{i} = fft2(gabbaba, imSizeY, imSizeX);
            gabFilt{nPatches+1} = gabFilt{nPatches+1} + gabFilt{i};
        end
        
        
        out = gabFilt;   
        
    
end