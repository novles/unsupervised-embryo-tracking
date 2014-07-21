% unsupervised-embyo-tracking

% Magic numbers:
% TODO: Find paper's values for gaborStd, gaborLambda
nPatches = 16; % Number of rotated gabor patches in filter bank
nPatches_ = floor(nPatches/2); % Number of modified gabs
gaborStd = 4; % Standard deviation of gabor patches
gaborLambda = gaborStd*3; % Wavelength of gabor patch
genFigures = false; % Draw debug figures;

% Generate gabor patches.
rotation =  0:pi/nPatches:pi-pi/nPatches;
gaborPatch = @(r) gabor_patch(gaborStd, r, gaborLambda, 0, .5);
gabor = arrayfun(gaborPatch, rotation, 'UniformOutput', false);

gaborSize = size(gabor{1},1);

% for i = 1:nPatches
%     gabor_{i} = padarray(gabor{i},[gaborSize - size(gabor{i},1) gaborSize - size(gabor{i},2)],'replicate','post')
% end
% 
% gabor__ = cell(1,nPatches_);
% for i = 1:nPatches_
%     gabor__{i} = gabor_{2*i-1} + gabor_{2*i}
% end

% If debugging, show gabor patches
if genFigures
  figure('name', 'Gabor Patches');
  m = ceil(sqrt(nPatches));
  for i = 1:nPatches;
    subplot(m, m, i)
    imshow(uint8(renorm(gabor{i}, 0, 255)));
    title(sprintf('%.2f pi', rotation(i)/pi))
  end
end

% Load one image for now.
% TODO: Load all the images
image = double(imread('MouEmbTrkDtb\E00\Frame001.png'));


%grad = gradient((image));


% imFFT = fftshift(fft2(image));
% imLP_ = imFFT((480-100)/2+1:(480+100)/2,(480-100)/2+1:(480+100)/2);
% imLP = padarray(imLP_, [190 190]);
% imOut = abs(ifft2(ifftshift(imLP)));
grad = (gradient(log(image)));

% correlate gabor filters with gradient/
filtfun = @(gb) power(filter2(gb, grad),2);
filtGrad = cellfun(filtfun, gabor, 'UniformOutput', false);

% If debugging, show result of convolution
if genFigures
  figure('name', 'Filtered Gradient');
  m = ceil(sqrt(nPatches));
  for i = 1:nPatches;
    subplot(m, m, i)
    imshow(uint8(renorm(filtGrad{i}, 0, 255)));
    title(sprintf('%.2f pi', rotation(i)/pi))
  end
end


result = 0;
dim = max(size(filtGrad{1}));

for i = 1:16
    result = result + filtGrad{i}; %+ im2bw(normalize(filtGrad{i}),0.4);
end

figure(1);
imshow(normalize(result));