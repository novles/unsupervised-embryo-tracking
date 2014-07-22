function out = gabCurve(stdDev,curveAngle,lambda,psi, radius, arcAngle, gamma, cropBool)


    switch nargin
        case 7
            cropBool = true;
    end

    
    gamma = min(gamma,5); %'cause past 5 it starts looking weird.
    
    
    kernScale = 4; % Magic number. This is here so the circle is smoother

    gab_ = gabor_patch(stdDev*kernScale, 0, lambda*kernScale, psi , gamma);
    gabMaxVal = max(gab_(:));
    gabMinVal = min(gab_(:));
    xGab = size(gab_,2);
    yGab = size(gab_,1);
    gabMax = max(xGab,yGab);
    gabSize = [xGab yGab];
    
    %gab_ = imresize(padarray(gab__, gabPad, 'replicate'),kernScale);
    %kernSize = ceil(ceil([radius radius]/2)*4*kernScale + [gabMax gabMax]); %Done so the image comes out even number. Symmetry!
    kernSize = ceil([radius radius]*2*kernScale + [gabMax gabMax]);

    numThreads = 32; % Magic~~
    
    kern__ = cell(numThreads);
    
    iterations = (radius*kernScale*arcAngle/2);
    
    

    parfor i = 1:numThreads
        kern__{i} = zeros(kernSize);
        for j = i:numThreads:iterations

            kernAngle = arcAngle*( (j/iterations) - 0.5 ) + curveAngle;
            
            gab = gabor_patch(stdDev*kernScale, kernAngle, lambda*kernScale, psi , gamma, gabMax);
%             xGab = size(gab_,2);
%             yGab = size(gab_,1);
%             
%             gabPad = floor([abs(yGab-gabMax) abs(xGab-gabMax)]/2);
%             gab = padarray(gab_, gabPad, 'replicate');
%             
            xPos = floor(radius*kernScale*(cos(kernAngle)+1))+1;
            yPos = floor(radius*kernScale*(sin(kernAngle)+1))+1;
            
            %gab = imrotate(gab_,(-kernAngle)*(180/pi),'bilinear','crop');
            
            %[yPos xPos]
            kern__{i}(yPos:(yPos+gabMax-1),xPos:(xPos+gabMax-1)) = kern__{i}(yPos:(yPos+gabMax-1),xPos:(xPos+gabMax-1)) + gab;

        end
    end
    
    kern_ = zeros(kernSize);
    
    for i = 1:numThreads
        kern_ = kern_ + kern__{i};
    end
    
    %soh cah toa

    if cropBool == true
        arcStart = arcAngle*(1/iterations-0.5)+curveAngle;
        arcEnd = 0.5*arcAngle+curveAngle;
    else
        arcStart = 0;
        arcEnd = 2*pi;
    end

    arcAngles = arcStart:(1/iterations):arcEnd;

    xMin = min( radius*kernScale*(cos(arcAngles)+1) - abs(xGab*cos(arcAngles))/2 + 1);
    xMax = max( radius*kernScale*(cos(arcAngles)+1) + abs(xGab*cos(arcAngles)) + 1);
    yMin = min( radius*kernScale*(sin(arcAngles)+1) - abs(xGab*sin(arcAngles))/2 + 1);
    yMax = max( radius*kernScale*(sin(arcAngles)+1) + abs(xGab*sin(arcAngles)) + 1);
    cropBox = floor([[xMin+1 yMin+1] ([xMax yMax]-[xMin yMin])]);
    out = normalize(imresize(imcrop(kern_,cropBox),1/kernScale),gabMaxVal,gabMinVal);
    %out = imresize(imcrop(kern_,cropBox), 1/kernScale);
end
