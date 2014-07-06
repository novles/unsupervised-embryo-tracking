% unsupervised-embyo-tracking

% Magic numbers:
% TODO: Find paper's values for gaborStd, gaborLambda
nPatches = 16; % Number of rotated gabor patches in filter bank
gaborStd = 3; % Standard deviation of gabor patches
gaborLambda = 9; % Wavelength of gabor patch
genFigures = true; % Draw debug figures;

% Generate gabor patches.
rotation =  0:pi/nPatches:pi-pi/nPatches;
gaborPatch = @(r) gabor_patch(gaborStd, r, gaborLambda, 0, 1);
gabor = arrayfun(gaborPatch, rotation, 'UniformOutput', false);

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
image = double(imread('Frame001.png'));
grad = gradient(image);

% correlate gabor filters with gradient/
filtfun = @(gb) abs(filter2(gb, grad));
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
