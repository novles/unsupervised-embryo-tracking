% This function takes a current ellipse and returns difference information.


function out = makeEllipseFilt(stdDev,lambda, gamma, patches, majRad, minRad, imSizeX, imSizeY, phi)

    
    switch nargin
        case 3
            patches = 32; %More magic!!
            minRad = majRad;
            imSizeX = 480;
            imSizeY = 480;
            phi = 0;
        case 4
            minRad = majRad;
            imSizeX = 480;
            imSizeY = 480;
            phi = 0;
        case 5
            imSizeX = imSizeY;
            phi = 0;
        case 6
            phi = 0;
    end

    iterations = patches*2;
    
    gabMax = 128;

    ellipse_ = gabEllipse(stdDev,lambda,0, gamma, majRad, minRad, phi);
  
    ellipse_ = padarray(ellipse_,[gabMax gabMax],0,'both').^2;
  
    xPos_ = zeros(1,iterations);
    yPos_ = zeros(1,iterations);

    for i = 1:iterations

        ellipseAngle = (2*pi)*( (i/iterations) - 0.25 );

        xPos__ = majRad*cos(ellipseAngle);
        yPos__ = minRad*sin(ellipseAngle);

        r = nthroot((xPos__^2 + yPos__^2),2);
        theta = atan2(yPos__,xPos__)+phi;

        xPos_(i) = r*cos(theta);
        yPos_(i) = r*sin(theta);
        
    end

    gab = cell(1,iterations+1);
    gab{1} = 0;
    
    for i = 1:iterations
        
        xPos = floor(xPos_(i)+floor(size(ellipse_,2)/2)) + 1;% + xGab
        yPos = floor(yPos_(i)+floor(size(ellipse_,1)/2)) + 1;% + yGab

        xPos = xPos - floor(gabMax/2);
        yPos = yPos - floor(gabMax/2);

        gabbaba_ = ellipse_(yPos:(yPos+gabMax-1),xPos:(xPos+gabMax-1));
        gabbaba = padarray(gabbaba_,floor(([imSizeY imSizeX]-gabMax)/2),0,'both').^2;
        gab{i+1} = fft2(gabbaba);
        gab{1} = gab{1} + gab{i+1};
    end

    out = gab;

end
