%function out = cellFind(in)

    in = double(imread('MouEmbTrkDtb\E23\Frame001.png'));
    
    imSize = size(in);
    
    lpCutoff = 100;
    hpCutoff = 30;
    
%     imLP = zeros(size(in));
%     imHP = zeros(size(in));
%     
%     imLP((imSize(1)-lpCutoff)/2+1:(imSize(1)+lpCutoff)/2,(imSize(1)-lpCutoff)/2+1:(imSize(1)+lpCutoff)/2) = ones(lpCutoff,lpCutoff);
%     imHP((imSize(1)-hpCutoff)/2+1:(imSize(1)+hpCutoff)/2,(imSize(1)-hpCutoff)/2+1:(imSize(1)+hpCutoff)/2) = ones(hpCutoff,hpCutoff);
    imLP = zeros(size(in));
    imHP = zeros(size(in));
    
    imLP((imSize(1)-lpCutoff*2)/2+1:(imSize(1)+lpCutoff*2)/2,(imSize(1)-lpCutoff*2)/2+1:(imSize(1)+lpCutoff*2)/2) = imresize(fspecial('disk',lpCutoff),(lpCutoff*2)/(lpCutoff*2+1));
    imHP((imSize(1)-hpCutoff*2)/2+1:(imSize(1)+hpCutoff*2)/2,(imSize(1)-hpCutoff*2)/2+1:(imSize(1)+hpCutoff*2)/2) = imresize(fspecial('disk',hpCutoff),(hpCutoff*2)/(hpCutoff*2+1));
    
    imHP = im2bw(normalize(imHP),.1);
    imLP = im2bw(normalize(imLP),.1);
    
    imFilt = (1-(imHP)).*(imLP);
    
    imageFFT = (fftshift(imFilt).*fft2(in));

    image = in;% - abs((ifft2(imageFFT)));
    
    image = medfilt2(image,[10 10]);
    
    grad = (gradient((image))); %Applying the logarithm gives better response for the gab filters.
    
    %figure,imshow(normalize(image));
    
    %preprocess (I pulled out your code, Jason.)
    
    nPatches = 8; % Number of rotated gabor patches in filter bank
    gaborStd = 6; % Standard deviation of gabor patches
    gaborLambda = gaborStd*pi; % Wavelength of gabor patch
    gaborAspect = 10;

    
    gabSize = max(size(gabor_patch(gaborStd, 0, gaborLambda/2, 0, gaborAspect)));
    
    rotation =  0:pi/nPatches:pi-pi/nPatches;
    gaborPatch = @(r) (gabor_patch(gaborStd, r, gaborLambda, 0, gaborAspect, size(image,2), size(image,1)));
    gabor = arrayfun(gaborPatch, rotation, 'UniformOutput', false);
    
%     filtfun = @(gb) power(abs(fft2(gb)))),1); % Squaring it gives better contrast against the garbage noise.
%     gabPatch = 
%     
    %Convolve in frequency domain. Much faster.
    filtfun = @(gb) power(abs(ifftshift(ifft2(fft2(gb).*fft2(grad)))),1); % Squaring it gives better contrast against the garbage noise.
    filtGrad = cellfun(filtfun, gabor, 'UniformOutput', false);
    
    
    result = 0;
    
    for i = 1:nPatches
        result = result + filtGrad{i}; % The cell edge should now be clearly visible.
    end

    %figure(1);
    %imshow(normalize(result));
    
    
    
    % Because the result is squared, the gabor wavelength is halved.
   
    running = true;
    
    i = 0;
    
    %while running == true
        
        [maxVal, index] = max(result);

        [yPeak, xPeak] = ind2sub(size(result),index(1));

     %   if
    %end
    
    
    
    %Find first edge by 
%     while running == true && i ~= nPatches-1 
%         
%         angle = pi*(i/nPatches);
%         
%         gab = gabor_patch(gaborStd, angle, gaborLambda/2, 0, gaborAspect, size(image,2), size(image,1));
%         
%         loc = kernFind(gab,result)
%         
%         i = i+1;
%         
%     end
%     
    
    
    
%     
%     
%     
%     locBefore = kernFind(gabBefore,result);
%     locAfter = kernFind(gabAfter,result);
    
    
% for i = 1:2
%     
%     switch i
%         case 1
%             rUp = 
%         case 2
%             
%     end
% end
% 
% 
%     
    
   
%end