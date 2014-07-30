%function out = cellFind(in)

    

    in = double(imread('MouEmbTrkDtb\E06\Frame001.png'));
    
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
    
     kern = fspecial('gaussian',150,100);
     sizeEst = [300 300]; % 'cause most of 'em are radius 100, this should do
% %     
     firstEst = kernFind(kern,imageLP);
     medianFilt = medfilt2(imageFiltered,[20 20])
     grad = abs(gradient(medianFilt)); %Applying the logarithm gives better response for the gab filters.
    figure(1);
    imshow(imageLP);
    hold on
    plot(firstEst(2),firstEst(1),'ro')
        
    
%     figure(1);s
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
    nPatches = 8; % Number of rotated gabor patches in filter bank
    gaborStd = pi; % Standard deviation of gabor patches
    gaborLambda = gaborStd*2; % Wavelength of gabor patch
    gaborAspect = 10;

    
    Size = max(size(gabor_patch(gaborStd, 0, gaborLambda, 0, gaborAspect)));
    
    rotation =  0:pi/nPatches:pi-pi/nPatches;
    
    gabFilt = 0;
    
    figure(1);
    
    for i = 1:nPatches
        
        gabbaba = gabor_patch(gaborStd, (i-1)*pi/nPatches, gaborLambda, 0, gaborAspect, 32,32);
        
        hold on;
        subplot(ceil(sqrt(nPatches)),ceil(sqrt(nPatches)),i);
        imshow(normalize(gabbaba));
%         gabFilt = gabFilt + fft2(gabbaba);
    end
    
    LPConst = 3;
    
    gabFilt(1:LPConst,1:LPConst) = 0;
    gabFilt(1:LPConst,end-LPConst+1:end) = 0;
    gabFilt(end-LPConst+1:end,end-LPConst+1:end) = 0;
    gabFilt(end-LPConst+1:end,1:LPConst) = 0;
    result_ = 0;
    result = 0;
    
    result_ = gabFilt.*fft2(fftshift(grad));
    result = abs(power(ifft2(result_),2));
   
    
    cellCentre = [firstEst(1) firstEst(2)];
    cellTopC = cellCentre-floor(sizeEst/2);
    
    searchArea = imcrop(result,[cellTopC sizeEst]);
    search = cell(1,2);
    
    botY = floor(size(searchArea,1)/2);
    topY = ceil(size(searchArea,1)/2);
    search{2} = searchArea(1:botY,:);
    search{1} = searchArea(topY+1:end,:);
    
%     x = gabEllipse(gaborStd, gaborLambda/2, 0,.5,50,50);
    circleX = 0;
    circleY = 0;
%     for k = 0:1    
%      
%      [radius_ dist_] = findRadius(circleX(index-1),circleY(index),circleX(index),circleY(index),pi/4);
%      
%      radius = radius_ + radius;
%      adj_ = (dist_/2)*tan(pi/4);
%      
%      centre = centre + [min(circleX)+(dist_/2) min(circleY)+adj_]+cellTopC
%     end
     
     for i = 0:1
         
         index = i+1;%+2*k;
         %kern = gabor_patch(gaborStd, i*pi/2+pi/4, gaborLambda, 0, .2,64).^2;%gabCurve(gaborStd, i*pi/2+pi/4,gaborLambda,0,floor(max(sizeEst)/2),pi/8,1,true).^2;
         kern = gabCurve(gaborStd, i*pi/2+pi/4,gaborLambda,0,floor(max(sizeEst)/2),pi/8,1,true).^2;

         y =  kernFind(kern,search{1});
         
         circleX(index) = y(2);
         circleY(index) = y(1);
       
     end
      [radius dist] = findRadius(circleX(1),circleY(1),circleX(2),circleY(2),pi/4)
%      
      adj = (dist/2)*tan(pi/4);
%      
      centre = [  min(circleX)+(dist/2) min(circleY)+adj]+cellTopC;
%      
%     imshow(normalize(result)*40);
%     hold on
%     plot(circleX(1)+cellTopC(1),circleY(1)+cellTopC(2),'go');
%     plot(circleX(2)+cellTopC(1),circleY(2)+cellTopC(2),'go');
%     plot(centre(1), centre(2),'ro');
%     hold off
% %      
%      
%      searchBox = floor([centre-2*radius [radius radius]*4]);
%      
%      embryo = imcrop(result,searchBox);
%      
% %      embryoCrop = imcrop(result,searchBox);
% %      
% %      embryoWindow = lpGen(150,size(embryoCrop,2),size(embryoCrop,1));
% %      embryo = embryoCrop.*embryoWindow;
%      
%      
%     
%      
% 
%      test = gabEllipseFind(embryo,size(embryo,2)/2,size(embryo,1)/2, gaborStd,gaborLambda, 5,nPatches*4, radius);
%     
%     
% %     close all
% %     w = 1;
% %     X = 0;
% %     Y = 0;
% %     Z = 0;
% %     
% %     
% %     
% %     for i = 1:size(test{1,1},1)
% %             
% %         for j = 1:size(test{1,1},1)
% %             X(w) = i;
% %             Y(w) = j;
% %             Z(w) = test{1,1}(i,j);
% %             w = w+1;
% %         end
% %     end
% %     
% %     X = X';
% %     Y = Y';
% %     Z = Z';
% %     close all
% %     for i = 1:16
% %         
% % %         figure(2*i-1)
% % % %         imshow(normalize(abs(ifft2((test{i,2})))))
% % %         
% % %        
% %          figure(i)
% %          x = unwrap(unwrap(test{i,1},[],2),[],1);
% %          
% %          s = 4;
% %          
% %          surf(x(s+1:end-s,s+1:end-s)),shading flat;
% % %          surf(test{i,1}),view(2),shading flat;
% % %        imshow(normalize(angle(test{i,5}))),shading flat;
% % %         surf(unwrap(unwrap(fftshift(angle(test{i,5})),[],1),[],2))),shading flat;
% % %         surf(filter2(fspecial('gaussian',[7 7],5),unwrap(unwrap(fftshift(angle(test{i,5})),[],2),[],1))),shading flat;
% % % %        
% % %         
% % %         imshow(normalize(test{i,4}));
% % %         figure(4*i)
% % %         imshow(test{i,3});
% %     end
% 
%     
% %     figure(17)
% %     %imshow(normalize(embryo));
% %     for i = 1:16
% %         hold on;
% %         subplot(4,4,i);
% % %         imshow();
% % 
% %         imshow(normalize(test{i,5}));
% %     end
% %     
% %     plot(test{1,1}(2),test{1,1}(1));
%      
% %     
% %     
% %     
% %     
% %     