folder = 'MouEmbTrkDtb\E08\';


in_ = double(imread(strcat(folder,'Frame001.png')));
lpCutoff = 100;
hpCutoff = 20;

out = cellFind(in_,1.5);

centre = out(1:2);
rad = out(3);

imSize = size(in_);

gabStd = 5;
gabLam = gabStd*2;
gabAsp = 1;
nPatches = 8;

gabFilt = makeGabFilt(5, 10, 1, 8, imSize(2), imSize(1));

imFilt = lpGen(lpCutoff,imSize(2),imSize(1)).*hpGen(hpCutoff,imSize(2),imSize(1));

imageFFT = ((imFilt).*fftshift(fft2(in_)));
 
imageFiltered = abs(ifft2(imageFFT));% - abs((ifft2(imageFFT)));

medianFilt = medfilt2(imageFiltered,[20 20]);
grad = abs(gradient(medianFilt));

image = 0;

image = ifftshift(ifft2(fft2(grad).*gabFilt)).^2;

imSize = size(image);
gabFilt = makeGabFilt(gabStd, gabLam, gabAsp, nPatches, imSize(2), imSize(1));

[trueCentre majRad minRad phi] = gabEllipseFind(image,floor(imSize(2)/2),floor(imSize(1)/2),gabStd, gabLam, gabAsp, nPatches*4, rad);
trueCentre = floor(trueCentre);
rad = ceil((majRad+minRad)/2);

majLine = majRad*[cos(phi+pi/2) sin(phi+pi/2)] + trueCentre;
minLine = minRad*[cos(phi) sin(phi)] + trueCentre;

imshow(normalize(in_))
hold on
plot(trueCentre(2), trueCentre(1),'ro')
line([trueCentre(2) majLine(2)],[trueCentre(1) majLine(1)])
line([trueCentre(2) minLine(2)],[trueCentre(1) minLine(1)])
hold off




% searchBox = ceil([[centre(1) centre(2)]-rad*1.25 [rad rad]*2.5]/32)*32;
% in = imcrop(image,searchBox);
% 


% x = imhist(normalize(image),128); 
% histo = x./norm(x);
% [maxVal, maxBin] = max(histo);
% v = var(x);
% v = var(histo);
% bin_v = round(128/v);
% sigma = sqrt(v);
% bin_v = round(1/sigma);


for i = 1:300
    
    index = i+1
    
    fNum = sprintf('%3.3i',i);
    
    fileName = strcat('Frame',fNum,'.png');
    
    file = strcat(folder,fileName);
    in = double(imread(file));
%     
%     
%     in = imcrop(in_,searchBox);
%     
    imageFFT = ((imFilt).*fftshift(fft2(in)));

    imageFiltered = abs(ifft2(imageFFT));% - abs((ifft2(imageFFT)));
    medianFilt = medfilt2(imageFiltered,[20 20]);
    grad = abs(gradient(medianFilt));
    
    image = ifftshift(ifft2(fft2(grad).*gabFilt).^2);
    
    
    
    [cent majRad(index) minRad(index) phi(index)] = gabEllipseFind(image,cent(2),cent(1), gabStd,gabLam,gabAsp,nPatches*4,majRad(i),minRad(i),phi(i));
    trueCentre(index,:) = floor(cent);
    majRad(index) = floor(majRad(index));
    minRad(index) = floor(minRad(index));
    
    cropConst = 1.25;
    
    cropBox = [trueCentre(i,:)-majRad(i)*cropConst [majRad(i) majRad(i)]*cropConst*2];
    
    figure(1);
    imshow(normalize(imcrop(medianFilt,cropBox)));
    
    majLine = 0;
    minLine = 0;
    
    majLine = majRad(i).*[cos(phi(i)+pi/2) sin(phi(i)+pi/2)] + cent;
    minLine = minRad(i).*[cos(phi(i)) sin(phi(i))] + cent;
    figure(2);
    imshow(normalize(in))
    hold on
    plot(trueCentre(i,2), trueCentre(i,1),'ro')
    line([trueCentre(i,2) majLine(2)],[trueCentre(i,1) majLine(1)])
    line([trueCentre(i,2) minLine(2)],[trueCentre(i,1) minLine(1)])
    hold off



    
    
    
    histo = imhist(image);
%     histo = x./norm(x);
%     [maxVal, maxBin] = max(histo);
%     v_ = var(histo);
%     v(i) = sum(v_);
    v(i) = var(histo);
%     h = imhist(image);
%     v(i) = var(h);
%     x = imhist(normalize(image),128);
%     histo = x./norm(x);
%     [maxVal, maxBin] = max(histo)
%     v = var(x);
%     v = var(histo);
%     bin_v = round(128/v);
%     sigma = sqrt(v);
%     bin_v = round(1/sigma);
%     
%     
%     
%     subplot(3,1,1);
%     imshow(image);
%     subplot(3,1,2);
%     plot(h);
%     subplot(3,1,3);
%     pause
%     
end
    
    