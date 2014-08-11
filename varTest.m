startImage = 1;
folder = 'MouEmbTrkDtb\E01\';

gabStd = 10;
gabLam = gabStd*2;
gabAsp = 10;
gabPhi = pi;
nPatches = 16;
mfSize = 20;
lpCutoff = 100;
hpCutoff = 20;
flen = 10;
fdelay = 0;
dflen = 10;
dfdelay = 0;
checkback = 5;


fNum = sprintf('%3.3i',startImage);
fileName = strcat('Frame',fNum,'.png');
file = strcat(folder,fileName);
% in_ = histeq(imread(file),256);
% in = double(in_);

in = double((imread(file)));


out = cellFind(in,1.25);

% centre = out(1:2);
% rad = out(3);
centre = out;
rad = 85;
imSize = size(in);



gabFilt = makeGabFilt(gabStd, gabLam, gabAsp, nPatches, imSize(2), imSize(1), gabPhi);

imFilt = lpGen(lpCutoff,imSize(2),imSize(1)).*hpGen(hpCutoff,imSize(2),imSize(1));

imageFFT = ((imFilt).*fftshift(fft2(in)));
 
imageFiltered = abs(ifft2(imageFFT));% - abs((ifft2(imageFFT)));

% medianFilt = medfilt2(imageFiltered,mfSize);

x = imageFiltered;
    
for i = 1:mfSize
    x = medfilt2(rot90(x,1),ceil([i i]/2));
end

medianFilt = x;


grad = abs(gradient(medianFilt));

image = 0;
image = sqrt(ifftshift(ifft2(fft2(grad).*gabFilt)).^2);

imSize = size(image);
gabFilt = makeGabFilt(gabStd, gabLam, gabAsp, nPatches, imSize(2), imSize(1));

[trueCentre, majRad, minRad, phi, initialCropBox] = gabEllipseFind(image,centre(1),centre(2),gabStd, gabLam, gabAsp, nPatches*4, rad);
trueCentre = floor(trueCentre);
rad = ceil((majRad+minRad)/2);

majLine = majRad*[cos(phi+pi/2) sin(phi+pi/2)] + trueCentre;
minLine = minRad*[cos(phi) sin(phi)] + trueCentre;

imshow(normalize(in));

hold on
plot(trueCentre(2), trueCentre(1),'ro')
line([trueCentre(2) majLine(2)],[trueCentre(1) majLine(1)])
line([trueCentre(2) minLine(2)],[trueCentre(1) minLine(1)])
hold off
% 
% result = imcrop(medianFilt, initialCropBox);
result = imcrop(in,initialCropBox);
imSize = size(result);
histo = imhist(normalize(result));

v = var(histo);
v_(1:flen) = v;
v_off = v;
vf = zeros(1,flen+1);
dv = 0;
dv_(1:dflen) = 0;
dvf = 0;


vf_taps = exp((1:flen)./flen);
vf_taps = vf_taps./sum(vf_taps);
dvf_taps = exp((1:dflen)./dflen);
dvf_taps = dvf_taps./sum(dvf_taps);
% gabFilt = makeGabFilt(gabStd, gabLam, gabAsp, nPatches, imSize(2), imSize(1));
% imFilt = lpGen(lpCutoff,imSize(2),imSize(1)).*hpGen(hpCutoff,imSize(2),imSize(1));


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

cent = [centre(2) centre(1)];

w = 0;
g = 1;



cropBox = initialCropBox;
imFilt = lpGen(lpCutoff,imSize(1),imSize(2)).*hpGen(hpCutoff,imSize(1),imSize(2));
%gabFilt = makeGabFilt(gabStd, gabLam, gabAsp, nPatches, imSize(2), imSize(1));
gabFilt = makeGabFilt(gabStd, gabLam, gabAsp, nPatches, imSize(2), imSize(1));

for i = 1:(300 - startImage-1);
    
    index = i+1

    imageNum = i+startImage;
    fNum = sprintf('%3.3i',imageNum);

    fileName = strcat('Frame',fNum,'.png');

    file = strcat(folder,fileName);
    in_ = double(imread(file));
    result = imcrop(in_,cropBox);
    
%     imageFFT = ((imFilt).*fftshift(fft2(result)));
% 
%     imageFiltered = abs(ifft2(imageFFT));% - abs((ifft2(imageFFT)));
% 
% %     medianFilt = medfilt2(imageFiltered,[10 10]);
%     x = imageFiltered;
    x = result;
    
    for j = 1:mfSize
        x = medfilt2(rot90(x,1),ceil([j j]/2));
    end

    medianFilt = x;    
    
    grad = abs(gradient(medianFilt));

    image = 0;

    image = abs(ifftshift(ifft2(fft2(grad).*gabFilt)));

    histo = imhist(x);

    v(index) = var(histo);
    vindst = max(1,i-flen);
    vindend = max(1,i);
    v_min(i) = min(v(vindst:vindend));
    v_max(i) = max(v(vindst:vindend));
    v_off(index) = (v_min(i) + v_max(i))/2;
    
    dvindst = max(1,i-dflen-dfdelay);
    dvindend = max(1,i-dfdelay);     
    dv(index) = (v(index)-v(i));
    dv_min(index) = median(min(dv(vindst:vindend)));
    dv_max(index) = median(max(dv(vindst:vindend)));
    dv_med(index) = median(abs(dv(vindst:vindend)));
%     dvf(index) = dv(dvindst:dvindend));
    checkst = max(1,i-checkback);
    if (v_off(i)+dv_max(i)+dv_med(i)) < (v_off(i)-dv_min(i)-dv_med(i))
        w = w+1;
        if w > checkback
            x(g) = i-dflen-checkback;
            
            g = g+1;
        end
    else
        w = max(0,w-1);
    end
    
    histo2 = imhist(result);

    v2(index) = var(histo);
    v2indst = max(1,i-flen);
    v2indend = max(1,i);
    v2_min(i) = min(v2(vindst:vindend));
    v2_max(i) = max(v2(vindst:vindend));
    v2_off(index) = (v2_min(i) + v_max(i))/2;
    
    dv2indst = max(1,i-dflen-dfdelay);
    dv2indend = max(1,i-dfdelay);     
    dv2(index) = (v2(index)-v(i));
    dv2_min(index) = median(min(dv2(vindst:vindend)));
    dv2_max(index) = median(max(dv2(vindst:vindend)));
    dv2_med(index) = median(abs(dv2(vindst:vindend)));
    
    resf = fft2(result);
    resp = resf.^2;
    resp_sum(i) = sum(resp(:));
    
    
end
hold on
plot(v,'g');
plot(v_off,'r');
hold on
plot(v)
plot(v_off+dv_max+dv_med,'r')
plot(v_off-dv_min-dv_med,'g')





% for i = 1:(300 - startImage-1);
%     
%     index = i+1
% 
%       
%         
%         
%         imageNum = i+startImage;
%         fNum = sprintf('%3.3i',imageNum);
% 
%         fileName = strcat('Frame',fNum,'.png');
% 
%         file = strcat(folder,fileName);
%         in_ = imread(file);
% %         in = double(medfilt2(in_,mfSize));
% %         result = histeq(imcrop(in_,initialCropBox),256);
%          result = imcrop(in_,initialCropBox);
%     %     
%     %     
%     %     in = imcrop(in,searchBox);
%     %     
% %         imageFFT = ((imFilt).*fftshift(fft2(in)));
% % 
% %         imageFiltered = abs(ifft2(imageFFT));% - abs((ifft2(imageFFT)));
% %         medianFilt = medfilt2(imageFiltered,mfSize);
% %         grad = abs(gradient(medianFilt));
% % 
% %         image = ifftshift(ifft2(fft2(grad).*gabFilt).^2);
% 
% %         [cent, majRad(index), minRad(index), phi(index), cropBox] = gabEllipseFind(image,cent(2),cent(1), gabStd,gabLam,gabAsp,nPatches*4,majRad(i),minRad(i),phi(i));
% %         
% % %         [cent, majRad(index), minRad(index), phi(index), cropBox] = gabEllipseFind(image,cent(2),cent(1), gabStd,gabLam,gabAsp,nPatches*4,majRad(i),minRad(i),phi(i));
% %         
% %         trueCentre(index,:) = floor(cent);
% %         majRad(i) = floor(majRad(i));
% %         minRad(i) = floor(minRad(i));
% % % 
% % %         result = normalize(imcrop(medianFilt,cropBox));
% %         
%         
% 
% %         result = imcrop(medianFilt,initialCropBox);
% %         figure(1);
% %         imshow(normalize(result));
% 
% %         majLine = 0;
% %         minLine = 0;
% % 
% %         majLine = majRad(index).*[cos(phi(index)+pi/2) sin(phi(index)+pi/2)] + cent;
% %         minLine = minRad(index).*[cos(phi(index)) sin(phi(index))] + cent;
% %         figure(2);
% %         imshow(normalize(image))
% %         hold on
% %         plot(trueCentre(index,2), trueCentre(index,1),'ro')
% %         line([trueCentre(index,2) majLine(2)],[trueCentre(index,1) majLine(1)])
% %         line([trueCentre(index,2) minLine(2)],[trueCentre(index,1) minLine(1)])
% %         hold off
% 
%         histo = imhist(result);
%         
%         v(index) = var(histo);
%         vf(index) = filter(1,[1 -.1],v(index));
% %         v_(index+flen) = v(index);
% %         vf(max(1,i-flen):index) = medfilt1(v(max(1,i-flen):index),flen);
% %         vf(i) = median(v_(i:i+flen-1));
% %          vf(i:i+flen-1) = filter(vf_taps,1,[v_(i:(i+flen-2)) v(index)]);
% %         
% %         dv(index) = abs(v(index)-v(i));
% %         dv_(i+dflen) = dv(index);
% % %         dvf(i+dflen) = 0;
% %         dvf(i) = median(dv_(i:i+dflen-1));
% %          dvf(i:i+dflen-1) = filter(dvf_taps,1,[dv_(i:(i+dflen-2)) dv(index)]);
% 
% %         dv(index) = v(index)-v(i);
% %         
% %         if(dv(i)^2 > 1e10)
% %             'a thing happened!'
% %             i
% % %             pause
% %         end
% %         
% %         ddv(index) = dv(index)-dv(i);
% %         figure(2);
% %         plot(histo);
%     %     subplot(3,1,1);
%     %     imshow(image);
%     %     subplot(3,1,2);
%     %     plot(h);
%     %     subplot(3,1,3);
%     %     pause
%     %     
% end

% v(1:end-1) = v(2:end);
% dv(1:end-2) = dv(3:end);
% ddv(1:end-3) = ddv(4:end);
% 
%     
    