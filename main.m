% figure(26),imshow(normalize(cutout));
% 
% 
% images = cell(10);
% 
% for i = 1:5
%     
%     
%     filename = strcat('Proj\MouEmbTrkDtb\E01\Frame',num2str((i-1)*36+1,'%03d'),'.png');
%     
%     fullImage = imread(filename);
%     
%     images{i} = fullImage(xCutout,yCutout);
%     figure(i);
%     imshow(images{i});
%     
% end


numGabs = 5;
gabJump = 360/numGabs;

stDev = 4;
lam = stDev*3;



image = double(imread('Proj\MouEmbTrkDtb\E00\Frame101.png'));
figure(1);
hold on
subplot(2,1,1);
imshow(normalize(log(image)));
grad = gradient(log(image));
subplot(2,1,2);
imshow(normalize(grad));


gabs = cell(1,numGabs);
lGabs = cell(1,numGabs);
cGabs = cell(1,numGabs);
outIm = cell(1,numGabs);
outImStr = cell(1,numGabs);
outImCurv = cell(1,numGabs);


f1 = 'image';
f2 = 'fft';


parfor i = 1:numGabs
    
    image = gabor_patch(stDev, i*(gabJump*(pi/180)), lam, 0, 1);
    imFFT = fftshift(fft2(image));
    
    gabs{i} = struct(f1, image, f2, imFFT);

end

parfor i = 1:numGabs
    
    image = gabor_patch(stDev, i*(gabJump*(pi/180)), lam, 0, .5);
    imFFT = fftshift(fft2(image));
    
    lGabs{i} = struct(f1, image, f2, imFFT);

end

parfor i = 1:numGabs

    image = gabCurve(stDev, 10, lam, 0, 100 , (i*gabJump)*(pi/180));
    imFFT = fftshift(fft2(image));
    
    cGabs{i} = struct(f1, image, f2, imFFT);
    
end
