% This function takes a current ellipse and returns difference information.


function [centre majorRad minorRad phi] = gabEllipseFind(in, xCentre,yCentre, stdDev,lambda, gamma, patches, majRad, minRad, phi)

    
    switch nargin
        case 7
            patches = 32; %More magic!!
            minRad = majRad;
            phi = 0;
        case 8
            minRad = majRad;
            phi = 0;
        case 9
            phi = 0;
    end
    

   
   
    gab_ = gabor_patch(stdDev, 0, lambda, 0, gamma);
    xGab = size(gab_,2);
    yGab = size(gab_,1);
    
    iterations = patches*2;
    
    radius = (majRad+minRad)/2;
    
    fudge = 1.1;
    
    upscale = 1; % Magic number. frequency domain, man s'legit.
    gabMax = 96;
% %     gabMax = floor(min(max(xGab,yGab)*2,128));
%     gabMin = max(xGab,yGab);
%     kernMax = max(minRad, majRad);
%     
     
%    inSize = ceil([kernMax kernMax]*2 + [gabMax gabMax]) ;
%     

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

    inSize = size(in);
    pad = ceil(max(0, (max(max(xPos_)+xCentre, max(yPos_)+yCentre)+gabMax*8)-max(inSize))/2);
    inPadded = padarray(in, [pad pad],0,'both');
    
    inScaled = imresize(inPadded,upscale);
    
    gabMax = gabMax*upscale;
    pad = pad*upscale;
    
    inSize = size(inScaled);
    
    w = 1;
    
    store = zeros(iterations,5);
    result = cell(iterations,5);
    nTheta = 0;
    loc = [0 0];
    prevLoc = [0 0];
    
    gab = cell(1,iterations);
    
    for i = 1:iterations
        
        xPos = floor(xPos_(i)+floor(size(ellipse_,2)/2)*upscale) + 1;% + xGab
        yPos = floor(yPos_(i)+floor(size(ellipse_,1)/2)*upscale) + 1;% + yGab

        xPos = xPos - floor(gabMax/2);
        yPos = yPos - floor(gabMax/2);

        gab{i} = ellipse_(yPos:(yPos+gabMax-1),xPos:(xPos+gabMax-1));

    end
   
    
    distWeight = normalize(fspecial('gaussian',gabMax,(gabMax/4)));
    distnWeight = 1-distWeight; 
    
    edgeLocEst(iterations,:) = [xPos_(iterations) yPos_(iterations)];
    
    for i = 1:iterations
        prev = mod(i-2,iterations)+1;
        curr = mod(i-1,iterations)+1;
        next = mod(i,iterations)+1;

        xLine = (xPos_(next)-xPos_(curr));
        yLine = (yPos_(next)-yPos_(curr));
        nTheta = atan2(yLine, xLine)+pi/2;
        %gab = nthroot(power(gabor_patch(stdDev*upscale, nTheta, lambda*upscale, 0 , gamma, gabMax),2),2);
        
        xPos = (floor((xPos_(i) + xCentre)*upscale + pad) + 1);% + xGab
        yPos = (floor((yPos_(i) + yCentre)*upscale + pad) + 1);% + yGab
        xMax = (xPos+gabMax-1);
        yMax = (yPos+gabMax-1);
        add = 2;
        xPos = xPos - gabMax/2-add;
        xMax = xMax - gabMax/2+add;
        yPos = yPos - gabMax/2-add;
        yMax = yMax - gabMax/2+add;
        
        crop = inScaled(yPos:yMax,xPos:xMax);
        
        est = kernFind(gab{i}, crop);
%         figure(1),hold on;
%         subplot(ceil(sqrt(iterations)),ceil(sqrt(iterations)),i);
%         imshow(normalize(gab{i}));
%         figure(2),hold on
%         subplot(ceil(sqrt(iterations)),ceil(sqrt(iterations)),i)
%         imshow(normalize(crop));
%         hold on
%         plot(est(2),est(1),'ro');
%         plot(gabMax/2+add,gabMax/2+add,'go');
        est = floor((est + [yPos xPos]));
       
        edgeLocEst(curr,:) = [est(1) est(2)];
        ellipseAngle = (2*pi)*( (i/iterations));
        
        
        
        
         
%         gcMult = crop.*gab{i};
%         
%         gcFFT = fft2(gcMult);
%         
%         convolved = gabFFT.*conj(gcFFT);
%         
% %         
% %         angleSurf = filter2(fspecial('gaussian',[10 10],5),unwrap(unwrap(fftshift(angle(convolved)),[],2),[],1));
% %         asGrad = filter2(fspecial('gaussian',[10 10],5),gradient(angleSurf));
%         angleSurf = fftshift(angle(convolved));
%         
%         result{i,1} = angleSurf;
%         result{i,3} = gab{i};
%         result{i,4} = crop;
%         result{i,5} = gcMult;
%         
%         
%         
%         
% %         result{i,1} = gab;
% %         result{i,2} = gabFFT;
% %         result{i,3} = crop;
% %         result{i,4} = gcFFT;
% %         result{i,5} = conv;
% %         
%         xPos = xPos - gabMax;
%         yPos = yPos - gabMax;
%         
%         %[xPos xMax yPos yMax xGabMax yGabMax]
%         
%         curveCrop = inPadded(yPos:yMax,xPos:xMax);
%         gabPatch = gab(1:gabMax,1:gabMax);
%         loc = kernFind(gabPatch,curveCrop);
%         prevLoc = store(prev,1:2);
%         
%         xLinePrev = (xPos_(curr)-xPos_(prev));
%         yLinePrev = (yPos_(curr)-yPos_(prev));
%         prevTheta = atan2(yLinePrev, xLinePrev)+pi/2;
%         dTheta = nTheta-prevTheta
%         
%         
%         [rad dist] = findRadius(prevLoc(1),prevLoc(2),loc(1),loc(2),dTheta);
% 
%         
%         
%         
%          store(i,1:2) = loc;
%          store(i,3) = rad;
%          store(i,4) = nTheta;
        
        
        
%         result{i,1}(1) = result{i,1}(1) + yPos - pad;
%         result{i,1}(2) = result{i,1}(2) + xPos - pad;
%         
%         result{i,2} = curveCrop;
%         result{i,3} = gabPatch;
% 
     end
    
%     radfilt = medfilt1(store(:,3),3);
% %     
%      plot(radfilt);
%     rads = 0;
%     for i = 1:iterations
%         rad = radfilt(i)
%         if radius/fudge < rad && rad < radius*fudge
%             rads(w,1) = rad;
%             rads(w,2) = store(i,4);
%             rads(w,3) = i;
%             w = w+1;
%         end
%     end
%     
%     [maxR maxi] = max(rads(:,1))
%     [minR mini] = min(rads(:,1))
%     
%     
%     major = maxR;
%     maTheta = rads(maxi,2);
%     minor = minR;
%     miTheta = rads(mini,2);
%     
%     
%     
%     out = [major minor maTheta miTheta];

    for i = 0:floor((iterations-1)/2)

        indexOpp = mod(i-floor((iterations/2)),iterations)+1;
        index = i+1;
        point1 =  [edgeLocEst(index,1), edgeLocEst(index,2)];
        point2 =  [edgeLocEst(indexOpp,1), edgeLocEst(indexOpp,2)];

        cent(index,:) = (point1+point2)/2;

        rad(index) = findRadius(point1(2),point1(1),point2(2),point2(1), pi);
        
        

        %         edgeLocEst(index,3) = rad;

    end

    [majorRad maxInd] = max(rad);
    [minorRad minInd] = min(rad);
    
    phi = pi*((maxInd)+(minInd-(iterations/4)))/iterations;
    
    centre = round(mean(cent))-pad;
    
    
%     
     result = edgeLocEst;
    
  
end
