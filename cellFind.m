%function out = cellFind(in)

    

    in = double(imread('MouEmbTrkDtb\E03\Frame001.png'));
    
    imSize = size(in);
    
    lpCutoff = 100;
    hpCutoff = 1;
    

    imFilt = lpGen(lpCutoff,imSize(2),imSize(1)).*hpGen(hpCutoff,imSize(2),imSize(1));
    
    imageFFT = ((imFilt).*fftshift(fft2(in)));

    imageFiltered = abs(ifft2(imageFFT))-in;% - abs((ifft2(imageFFT)));
    
%     imageMedFilt = medfilt2(imageFiltered,[10 10]);
%     image = imageMedFilt;
%     
    imageLP = abs(ifft2(lpGen(5,imSize(2),imSize(1)).*fftshift(fft2(in))));

%     kern = fspecial('disk',50);
% %  
    
     kern = gabCurve(40,0,200,0,50,2*pi,1);
     sizeEst = size(kern);
% %     
     firstEst = kernFind(kern,imageLP);
%     
     grad = abs(gradient(medfilt2(imageFiltered,[20 20]))); %Applying the logarithm gives better response for the gab filters.
    
    
        
    
%     figure(1);
%     hold on;
%     subplot(1,3,1);
%     imshow(normalize(in));
%     
%     
%     figure(1);
%     hold on;
%     subplot(1,3,2);
%     imshow(normalize(imFilt));
%     
%     figure(1);
%     hold on;
%     subplot(1,3,3);
%     imshow(normalize(imageFiltered));
%     
%     figure(2);
%     hold on;
%     subplot(1,2,1);
%     imshow(normalize(image));
%     
%     figure(2);
%     hold on;
%     subplot(1,2,2);
%     imshow(normalize(grad));
      
%     %figure,imshow(normalize(image));
%     
%     %preprocess (I pulled out your code, Jason.)
%     
    nPatches = 32; % Number of rotated gabor patches in filter bank
    gaborStd = 2*pi; % Standard deviation of gabor patches
    gaborLambda = gaborStd*2; % Wavelength of gabor patch
    gaborAspect = .5;

    
    gab
    Size = max(size(gabor_patch(gaborStd, 0, gaborLambda, 0, gaborAspect)));
    
    rotation =  0:pi/nPatches:pi-pi/nPatches;
    
    gabFilt = 0;
    
    for i = 1:nPatches
        gabFilt = gabFilt + fft2(gabor_patch(gaborStd, (i-1)*pi/nPatches, gaborLambda, 0, gaborAspect, size(image,2), size(image,1)));
    end
    
    result_ = gabFilt.*fft2(grad);
    result = nthroot(normalize((ifftshift(ifft2(result_))).^2),2);
   
    
    cellCentre = [firstEst(1) firstEst(2)];
    cellTopC = cellCentre-floor(sizeEst/2);
    
    searchArea = imcrop(result,[cellTopC sizeEst]);
    search = cell(1,2);
    
    botY = floor(size(searchArea,1)/2);
    topY = ceil(size(searchArea,1)/2);
    search{1} = searchArea(1:botY,:);
    search{2} = searchArea(topY+1:end,:);
    
%     x = gabEllipse(gaborStd, gaborLambda/2, 0,.5,50,50);
    circleX = 0;
    circleY = 0;
        
     for i = 0:1
         
         index = i+1;
         kern = gabor_patch(gaborStd, i*pi/2+pi/4, gaborLambda, 0, .1,64).^2;

         y =  kernFind(kern,search{1});
         
         circleX(index) = y(2);
         circleY(index) = y(1);
       
     end
     
     
     
     centre = [min(circleX)+(dist/2) min(circleY)+adj]+cellTopC;
     
     searchBox = floor([centre-2*radius [radius radius]*4]);
     
     
     
     embryoCrop = imCrop(result,searchBox);
     
     embryoWindow = lpGen(150,size(embryoCrop,2),size(embryoCrop,1));
     embryo = embryoCrop.*embryoWindow;
     
     
     
     test = gabEllipseFind(embryo,size(embryoCrop,2)/2,size(embryoCrop,1)/2, gaborStd,gaborLambda*sqrt(2), .5,nPatches, radius);
     
    for i = 1:4:16
        
        figure(2*i-1)
         imshow(normalize(abs(ifft2((test{i,2})))))
        
%         surf(filter2(fspecial('gaussian',[3 7],5),unwrap(unwrap(fftshift(angle(test{i,5})),[],2),[],1))),shading flat;
%         
        figure(2*i)
        imshow(normalize(test{i,3})),shading flat;
        
%         figure(4*i-1)
%         
%         imshow(test{i,1});
%         figure(4*i)
%         imshow(test{i,3});
    end

    
    
    figure(2)
    %imshow(normalize(embryo));
    for i = 1:16
        hold on;
%         subplot(4,4,i);
%         imshow();

        plot(test{i,1}(2),test{i,1}(1),'ro');
    end
    
    plot(test{1,1}(2),test{1,1}(1));
     
%     
%     
%     
%     
%     