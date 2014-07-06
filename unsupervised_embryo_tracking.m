% unsupervised-embyo-tracking

% Magic numbers:
nPatches = 16; % Number of rotated gabor patches in filter bank
genFigures = true; % Draw debug figures;

% Generate gabor patches.
rotation =  0:pi/nPatches:pi-pi/nPatches;
gaborPatch = @(r) gabor_patch(3, r, 3*pi, 0, 1);
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
  
  %for i = 1:m
  %  for j = 1:m
  %    if i*j <= nPatches
  %      subplot(m,m,(i-1)*m+j);
  %      show_patch(gabor{(i-1)*m+j});
  %    end
  %  end
  %end
%end

% Load one image for now.
% TODO: Load all the images
image = double(imread('Frame001.png'));
grad = gradient(image);

% Convolve gradient with gabor filters.
conv2fun = @(gb) conv2(grad, gb, 'same');
filtGrad = cellfun(conv2fun, gabor, 'UniformOutput', false);

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
