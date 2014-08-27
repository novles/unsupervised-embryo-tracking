function out = gabEllipse(stdDev,lambda,psi, gamma, xRad, yRad, phi)


    switch nargin
        case 6
            phi = 0;
    end

    
    gamma = min(gamma,5); %'cause past 5 it starts looking weird.
    
    
    kernScale = 1; % Magic number. This is here so the circle is smoother

    gab_ = gabor_patch(stdDev*kernScale, 0, lambda*kernScale, psi, gamma);
    xGab = size(gab_,2);
    yGab = size(gab_,1);
    gabMax = max(xGab,yGab);
    gabMin = max(xGab,yGab);
    kernMax = max(yRad, xRad);
    
    kernSize = ceil([kernMax kernMax]*2*kernScale + [gabMax gabMax]) ;
    
    numThreads = 32; % Magic~~
    iterations = ceil(max(xRad, yRad)*kernScale*(2*pi)/2);
    
    xPos_ = zeros(1,iterations);
    yPos_ = zeros(1,iterations);
    
    for i = 1:ceil(iterations)

        ellipseAngle = (2*pi)*( (i/iterations) - 0.5 );

        xPos__ = kernScale*xRad*cos(ellipseAngle);
        yPos__ = kernScale*yRad*sin(ellipseAngle);

        r = nthroot((xPos__^2 + yPos__^2),2);
        theta = atan2(yPos__,xPos__)+phi;

        xPos_(i) = r*cos(theta);
        yPos_(i) = r*sin(theta);
        
        

    end
    
    kern__ = cell(numThreads);
    
    
    parfor j = 1:numThreads
        kern__{j} = zeros(kernSize);
        for i = j:numThreads:ceil(iterations)

            curr = mod(i-1,iterations)+1;
            next = mod(i,iterations)+1;

            xLine = (xPos_(next)-xPos_(curr));
            yLine = (yPos_(next)-yPos_(curr));
            nTheta = atan2(yLine, xLine)+pi/2; 
            gab = gabor_patch(stdDev*kernScale, nTheta, lambda*kernScale, psi , gamma, gabMax);
        
            xPos = round(xPos_(i)+kernMax*kernScale) + 1;% + xGab
            yPos = round(yPos_(i)+kernMax*kernScale) + 1;% + yGab
            
            kern__{j}(yPos:(yPos+gabMax-1),xPos:(xPos+gabMax-1)) = kern__{j}(yPos:(yPos+gabMax-1),xPos:(xPos+gabMax-1)) + gab;

        end
    end
    
    kern_ = zeros(kernSize);
    
    for i = 1:numThreads
        kern_ = kern_ + kern__{i};
    end
    
    %soh cah toa
    
%     xMin = kernMax;
%     yMin = kernMax;
%     xMax = 0;
%     yMax = 0;
%     for i = 1:iterations
%         curr = mod(i-1,iterations)+1;
%         next = mod(i,iterations)+1;
% 
%         xLine = (xPos_(next)-xPos_(curr));
%         yLine = (yPos_(next)-yPos_(curr));
%         nTheta = -atan2(yLine, xLine)+pi/2; 
%         xMin = min(xMin, xPos_(curr)+kernMax*kernScale - abs(gabMax*sin(nTheta))/2 + 1);
%         xMax = max(xMax, xPos_(curr)+kernMax*kernScale + abs(gabMax*sin(nTheta)) + 1);
%         yMin = min(yMin, yPos_(curr)+kernMax*kernScale - abs(gabMax*cos(nTheta))/2 + 1);
%         yMax = max(yMax, yPos_(curr)+kernMax*kernScale + abs(gabMax*cos(nTheta)) + 1);
%         
%     end
    
    centre = kernMax*kernScale+xGab;
    
    xOffset = (kernScale*((xRad-yRad)*(2*cos(phi)^2 - 1))+((xRad+yRad)*kernScale+2*xGab))/2;
    yOffset = (kernScale*((xRad-yRad)*(2*sin(phi)^2 - 1))+((xRad+yRad)*kernScale+2*xGab))/2;
    
    xMin = floor(centre-xOffset);
    xMax = floor(centre+xOffset);
    yMax = floor(centre+yOffset);
    yMin = floor(centre-yOffset);

    cropBox = floor([([xMin+1 yMin+1]) ([xMax yMax]-[xMin yMin])]);

    out = imresize(imcrop(kern_,cropBox), 1/kernScale);
    %out = imresize(kern_,1/kernScale);
%     
%     arcStart = 0;
%     arcEnd = 2*pi;
% 
%     arcAngles = arcStart:(1/iterations):arcEnd;
% 
%     
%     cropBox = floor([[xMin+1 yMin+1] ([xMax yMax]-[xMin yMin])]);
% 
%     out = imresize(imcrop(kern_,cropBox), 1/kernScale);

    %out = imresize(kern_,1/kernScale);
end
