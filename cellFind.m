function out = cellFind(in,cropMult)

    switch nargin
        case 0
            cropMult = 1.5;
            in = double(imread('MouEmbTrkDtb\E06\Frame001.png'));   
        case 1
            cropMult = 1.5;
    end
    
    nPatches = 8; % Number of rotated gabor patches in filter bank
    gaborStd = 5; % Standard deviation of gabor patches
    gaborLambda = gaborStd*2; % Wavelength of gabor patch
    gaborAspect = 2;

    imSize = size(in);

    lpCutoff = 100;
    hpCutoff = 1;
    mfSize = 20;


    imFilt = lpGen(lpCutoff,imSize(2),imSize(1)).*hpGen(hpCutoff,imSize(2),imSize(1));

    imageFFT = ((imFilt).*fftshift(fft2(in)));

%     imageFiltered = abs(ifft2(imageFFT))-in;% - abs((ifft2(imageFFT)));
    imageFiltered = abs(ifft2(imageFFT));% - abs((ifft2(imageFFT)));

%     lpFilt = lpGen(5,imSize(2),imSize(1));

    x = imageFiltered;

    for i = 1:mfSize
        x = medfilt2(rot90(x,1),ceil([i i]/2));
    end

    medianFilt = x;
% 
     grad = abs(gradient(medianFilt)); %Applying the logarithm gives better response for the gab filters.

%     lpFilt = makeGabFilt(100, 10, 1, 8, imSize(2), imSize(1),0);
%     
    lpFilt = makeGabFilt(100, 10, 1, 64, imSize(2), imSize(1),0);
    
    imageLP = ifftshift(ifft2(lpFilt.*fft2(medianFilt)));
    
    sigma = 100/sqrt(-2*log(0.5));
    
%     kern = fspecial('gaussian',300,sigma);

    kern = ifft2(makeGabFilt(100, 10, 1, 64, 64, 64,0)); %gabor_patch(100,pi/2,400,pi/2,2,300,300);
    imshow(normalize(kern));
    
    sizeEst = [150 150]; % 'cause most of 'em are radius 100, this should do

    firstEst = kernFind(kern,imageLP);
    
    
%     
% 
%     gabFilt = 0;
% 
%     for i = 1:nPatches
%         gabbaba = gabor_patch(gaborStd, (i-1)*pi/nPatches, gaborLambda, pi, gaborAspect, imSize(2),imSize(1));
%         gabFilt = gabFilt + fft2(gabbaba);
%     end
%     
%     LPConst = 3;
% 
%     gabFilt(1:LPConst,1:LPConst) = 0;
%     gabFilt(1:LPConst,end-LPConst+1:end) = 0;
%     gabFilt(end-LPConst+1:end,end-LPConst+1:end) = 0;
%     gabFilt(end-LPConst+1:end,1:LPConst) = 0;
% 
%     result_ = gabFilt.*fft2(fftshift(grad));
%     result = abs(power(ifft2(result_),2));
% 
% 
%     cellCentre = [firstEst(1) firstEst(2)];
%     cellTopC = cellCentre-floor(sizeEst/2);
% 
%     searchArea = imcrop(result,[cellTopC sizeEst*2]);
%     search = cell(1,2);
% 
%     botY = floor(size(searchArea,1)/2);
%     topY = ceil(size(searchArea,1)/2);
%     search{2} = searchArea(1:botY,:);
%     search{1} = searchArea(topY+1:end,:);
% 
%     circle = zeros(2,2);
%     order = [  0 1 3 2];
% 
% 
%     for j = 0:1
%         jndex = j+1;
%         figure(jndex);
%         hold on;
%         for i = 0:1
%             index = i+1;%+2*k;
%             j_ = 2*j;
%             
%             kern = gabCurve(gaborStd, order(index+j_)*pi/2+pi/4,gaborLambda,0,floor(max(sizeEst)/2),pi/4,1,true).^2;
% 
%             y = kernFind(kern,search{jndex});
% 
%             subplot(2,2,3+i);
%             imshow(normalize(kern));
%             circle(index,1) = y(2);
%             circle(index,2) = y(1);
%         end
% 
%         subplot(2,1,1);
%         imshow(normalize(searchArea)*100);
%         hold on;
%         plot(circle(1,2),circle(1,1),'go')
%         hold on;
%         plot(circle(2,2),circle(2,1),'go')
% 
%         [radius(jndex) dist] = findRadius(circle(1,2),circle(1,1), circle(2,2),circle(2,1),pi/4);
%         adj = (dist/2)*tan(pi/4);    
%         centre_(jndex,:) = [  min(circle(1,1), circle(2,1))+(dist/2) min(circle(1,2), circle(2,2))+adj]+cellTopC;
% 
%     end
% 
% 
%     centre = (centre_(1,:) + centre_(2,:))./2;
%     rad = sum(radius)/2;
%     
% %     figure(1);
% %     imshow(normalize(in));
% %     hold on;
% %     plot(centre(1), centre(2),'ro');
% 
%     %searchBox = ceil([[centre(1) centre(2)]-rad*1.5 [rad rad]*3]/32)*32;
%     
%     
%     
%     out = [centre radius];
    
    out = firstEst;

%      test = gabEllipseFind(embryo,size(embryo,2)/2,size(embryo,1)/2, gaborStd,gaborLambda, 5,nPatches*4, radius);
end