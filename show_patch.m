function show_patch(gabor)
% Plot a gabor patch using imshow
  
  gabor = gabor - min(gabor(:))./(max(gabor(:)) - min(gabor(:)));
  imshow(uint8(256*gabor))
  
end
